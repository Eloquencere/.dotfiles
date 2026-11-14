#!/usr/bin/env bash
# Install one pinned OSS CAD Suite release into $DEST. Linux only.
#
#   ./fetch-oss-cad-suite.sh                 # defaults below
#   TAG=2026-11-12 ./fetch-oss-cad-suite.sh  # pin another stable release
#
# Already at TAG -> nothing happens, no network. Another TAG replaces the
# install after warning whether that is an upgrade or a downgrade. Stable only.

set -euo pipefail

TAG="${TAG:-2026-11-01}"                  # stable release tag (a date), no alpha/beta
DEST="${DEST:-$HOME/Tools/oss-cad-suite}" # install dir, fully replaced on version change

case "$DEST" in "/"|"$HOME") echo "error: refusing to wipe DEST='$DEST'" >&2; exit 1 ;; esac

case "$(uname -m)" in
  x86_64)  ASSET="linux-x64"   ;;
  aarch64) ASSET="linux-arm64" ;;
  *) echo "error: no prebuilt asset for linux-$(uname -m)" >&2; exit 1 ;;
esac

STAMP="${TAG//-/}"
INSTALLED="$(cat "$DEST/VERSION" 2>/dev/null | tr -d '[:space:]' || true)"

# --- already done? ---------------------------------------------------------
if [ "$INSTALLED" = "$STAMP" ] && [ -x "$DEST/bin/yosys" ]; then
  echo "oss-cad-suite $TAG already installed in $DEST, nothing to do."
  echo "  $("$DEST/bin/yosys" --version)"
  exit 0
fi

# --- stable release check --------------------------------------------------
gh_api() {
  curl -fsSL -H 'Accept: application/vnd.github+json' \
    "https://api.github.com/repos/YosysHQ/oss-cad-suite-build/$1"
}
latest_stable() {
  gh_api releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p'
}
# For a bad tag, the stable release it was probably aiming at, else the newest.
closest_stable() {
  local d="${TAG:0:10}"
  [[ $d =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && gh_api "releases/tags/$d" >/dev/null 2>&1 \
    && { echo "$d"; return; }
  latest_stable
}

# A tag that is missing, not a date, or flagged pre-release is refused.
RELEASE="$(gh_api "releases/tags/$TAG" 2>/dev/null || true)"
if [ -z "$RELEASE" ] || grep -q '"prerelease":[[:space:]]*true' <<<"$RELEASE"; then
  echo "error: '$TAG' is not a stable OSS CAD Suite release (tags are dates, e.g. 2026-11-12)." >&2
  echo "       closest stable release: $(closest_stable)" >&2
  exit 1
fi

# --- upgrade / downgrade notice -------------------------------------------
if [ -z "$INSTALLED" ]; then
  echo "installing oss-cad-suite $TAG -> $DEST"
elif [ "$INSTALLED" != "$STAMP" ]; then
  case "$INSTALLED" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
      if [ "$INSTALLED" -lt "$STAMP" ]; then MOVE="upgrade"; else MOVE="downgrade"; fi ;;
    *) MOVE="replace" ;;
  esac
  echo "warning: $DEST is at build $INSTALLED — installing $TAG will $MOVE it." >&2
fi

# --- fetch + extract ------------------------------------------------------
URL="https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${TAG}/oss-cad-suite-${ASSET}-${STAMP}.tgz"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

curl -fL --progress-bar -o "$TMP/suite.tgz" "$URL"
tar -xzf "$TMP/suite.tgz" -C "$TMP"
# extract-over-the-top would leave stale files, and we delete DEST below, so
# make sure the archive is what we expect first.
[ -x "$TMP/oss-cad-suite/bin/yosys" ] || { echo "error: unexpected archive layout in $URL" >&2; exit 1; }

rm -rf "$DEST"
mkdir -p "$(dirname "$DEST")"
mv "$TMP/oss-cad-suite" "$DEST"

echo "installed oss-cad-suite $TAG -> $DEST ($("$DEST/bin/yosys" --version))"
