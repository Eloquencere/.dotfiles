// Cursor warp trail, optimized for ghostty.
// Derived from github.com/sahaj-b/ghostty-cursor-shaders (MIT), same visual result.
//
// What changed vs. the original:
//   1. Bounding-box early-out: fragments outside the trail quad return the
//      terminal texture immediately, so the 4-segment SDF only runs on the
//      few thousand pixels the trail actually covers.
//   2. Fixed the shadowed `effectiveBlur`, which meant the "no antialiasing on
//      horizontal/vertical moves" fix never actually took effect.
//   3. Dead easing variants and unused constants removed.

// --- CONFIGURATION ---
vec4 TRAIL_COLOR = iCurrentCursorColor; // e.g. vec4(0.2, 0.6, 1.0, 0.5);
const float DURATION = 0.2;            // total animation time
const float TRAIL_SIZE = 0.8;          // 0.0 = corners move together, 1.0 = max smear
const float THRESHOLD_MIN_DISTANCE = 1.5; // min distance to show trail (cursor heights)
const float BLUR = 1.0;                // blur size in pixels (antialiasing)
const float TRAIL_THICKNESS = 1.0;     // 1.0 = full cursor height
const float TRAIL_THICKNESS_X = 0.9;
const float FADE_ENABLED = 0.0;        // 1.0 = fade gradient along the trail
const float FADE_EXPONENT = 5.0;

const float PI = 3.14159265359;

// EaseOutCirc. Swap for any of: x, 1.0-(1.0-x)*(1.0-x), 1.0-pow(1.0-x,3.0),
// sin(x*PI/2.0), 1.0+2.70158*pow(x-1.0,3.0)+1.70158*pow(x-1.0,2.0)
float ease(float x) {
    return sqrt(1.0 - pow(x - 1.0, 2.0));
}

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b) {
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfConvexQuad(in vec2 p, in vec2 v1, in vec2 v2, in vec2 v3, in vec2 v4) {
    float s = 1.0;
    float d = dot(p - v1, p - v1);
    d = seg(p, v1, v2, s, d);
    d = seg(p, v2, v3, s, d);
    d = seg(p, v3, v4, s, d);
    d = seg(p, v4, v1, s, d);
    return s * sqrt(d);
}

vec2 toClip(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance, float blurAmount) {
    return 1. - smoothstep(0., toClip(vec2(blurAmount, blurAmount), 0.).x, distance);
}

// dot_val in [-2,2]: >0.5 leading, >-0.5 side, else trailing
float getDurationFromDot(float dot_val, float DURATION_LEAD, float DURATION_SIDE, float DURATION_TRAIL) {
    float isLead = step(0.5, dot_val);
    float isSide = step(-0.5, dot_val) * (1.0 - isLead);
    float duration = mix(DURATION_TRAIL, DURATION_SIDE, isSide);
    return mix(duration, DURATION_LEAD, isLead);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);

    vec2 vu = toClip(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(toClip(iCurrentCursor.xy, 1.), toClip(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(toClip(iPreviousCursor.xy, 1.), toClip(iPreviousCursor.zw, 0.));

    vec2 centerCC = currentCursor.xy - (currentCursor.zw * offsetFactor);
    vec2 centerCP = previousCursor.xy - (previousCursor.zw * offsetFactor);

    float lineLength = distance(centerCC, centerCP);
    float minDist = currentCursor.w * THRESHOLD_MIN_DISTANCE;
    float baseProgress = iTime - iTimeCursorChange;

    if (lineLength <= minDist || baseProgress >= DURATION - 0.001) return;

    vec2 halfSizeCC = currentCursor.zw * 0.5;
    vec2 halfSizeCP = previousCursor.zw * 0.5;

    // Y (height) with TRAIL_THICKNESS
    float cc_center_y = currentCursor.y - currentCursor.w * 0.5;
    float cc_half_h = currentCursor.w * 0.5 * TRAIL_THICKNESS;
    // X (width) with TRAIL_THICKNESS_X
    float cc_center_x = currentCursor.x + currentCursor.z * 0.5;
    float cc_half_w = currentCursor.z * 0.5 * TRAIL_THICKNESS_X;
    vec2 cc_tl = vec2(cc_center_x - cc_half_w, cc_center_y + cc_half_h);
    vec2 cc_tr = vec2(cc_center_x + cc_half_w, cc_center_y + cc_half_h);
    vec2 cc_bl = vec2(cc_center_x - cc_half_w, cc_center_y - cc_half_h);
    vec2 cc_br = vec2(cc_center_x + cc_half_w, cc_center_y - cc_half_h);

    float cp_center_y = previousCursor.y - previousCursor.w * 0.5;
    float cp_half_h = previousCursor.w * 0.5 * TRAIL_THICKNESS;
    float cp_center_x = previousCursor.x + previousCursor.z * 0.5;
    float cp_half_w = previousCursor.z * 0.5 * TRAIL_THICKNESS_X;
    vec2 cp_tl = vec2(cp_center_x - cp_half_w, cp_center_y + cp_half_h);
    vec2 cp_tr = vec2(cp_center_x + cp_half_w, cp_center_y + cp_half_h);
    vec2 cp_bl = vec2(cp_center_x - cp_half_w, cp_center_y - cp_half_h);
    vec2 cp_br = vec2(cp_center_x + cp_half_w, cp_center_y - cp_half_h);

    // per-corner durations from alignment with the movement direction
    const float DURATION_TRAIL = DURATION;
    const float DURATION_LEAD = DURATION * (1.0 - TRAIL_SIZE);
    const float DURATION_SIDE = (DURATION_LEAD + DURATION_TRAIL) / 2.0;

    vec2 moveVec = centerCC - centerCP;
    vec2 s = sign(moveVec);

    float dot_tl = dot(vec2(-1., 1.), s);
    float dot_tr = dot(vec2(1., 1.), s);
    float dot_bl = dot(vec2(-1., -1.), s);
    float dot_br = dot(vec2(1., -1.), s);

    float isMovingRight = step(0.5, s.x);
    float isMovingLeft = step(0.5, -s.x);

    float dur_right_rail = getDurationFromDot((dot_tr + dot_br) * 0.5, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);
    float dur_left_rail = getDurationFromDot((dot_tl + dot_bl) * 0.5, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL);

    float dur_tl = mix(getDurationFromDot(dot_tl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL), dur_left_rail, isMovingLeft);
    float dur_bl = mix(getDurationFromDot(dot_bl, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL), dur_left_rail, isMovingLeft);
    float dur_tr = mix(getDurationFromDot(dot_tr, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL), dur_right_rail, isMovingRight);
    float dur_br = mix(getDurationFromDot(dot_br, DURATION_LEAD, DURATION_SIDE, DURATION_TRAIL), dur_right_rail, isMovingRight);

    float prog_tl = ease(clamp(baseProgress / dur_tl, 0.0, 1.0));
    float prog_tr = ease(clamp(baseProgress / dur_tr, 0.0, 1.0));
    float prog_bl = ease(clamp(baseProgress / dur_bl, 0.0, 1.0));
    float prog_br = ease(clamp(baseProgress / dur_br, 0.0, 1.0));

    vec2 v_tl = mix(cp_tl, cc_tl, prog_tl);
    vec2 v_tr = mix(cp_tr, cc_tr, prog_tr);
    vec2 v_br = mix(cp_br, cc_br, prog_br);
    vec2 v_bl = mix(cp_bl, cc_bl, prog_bl);

    // --- EARLY OUT: everything below only matters inside the trail's box ---
    float pad = (max(BLUR, 1.0) + 1.0) * 2.0 / iResolution.y;
    vec2 lo = min(min(v_tl, v_tr), min(v_bl, v_br)) - pad;
    vec2 hi = max(max(v_tl, v_tr), max(v_bl, v_br)) + pad;
    if (any(lessThan(vu, lo)) || any(greaterThan(vu, hi))) return;

    float sdfTrail = getSdfConvexQuad(vu, v_tl, v_tr, v_br, v_bl);
    float sdfCurrentCursor = getSdfRectangle(vu, centerCC, halfSizeCC);

    vec4 trail = TRAIL_COLOR;

    // no antialiasing on pure horizontal/vertical moves (avoids a pulse at rest)
    float isDiagonal = abs(s.x) * abs(s.y);
    float effectiveBlur = (BLUR < 2.5) ? mix(0.0, BLUR, isDiagonal) : BLUR;
    float shapeAlpha = antialising(sdfTrail, effectiveBlur);

    if (FADE_ENABLED > 0.5) {
        vec2 fragVec = vu - centerCP;
        float fadeProgress = clamp(dot(fragVec, moveVec) / (dot(moveVec, moveVec) + 1e-6), 0.0, 1.0);
        trail.a *= pow(fadeProgress, FADE_EXPONENT);
    }

    // newColor.a preserves the background alpha
    vec4 newColor = mix(fragColor, vec4(trail.rgb, fragColor.a), trail.a * shapeAlpha);

    // punch a hole so the current cursor draws on top of its own trail
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));

    fragColor = newColor;
}
