local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

config = {
    default_cursor_style = "SteadyBar",
    automatically_reload_config = true,
    window_close_confirmation = "NeverPrompt",
    adjust_window_size_when_changing_font_size = false,
    check_for_updates = false,
    enable_tab_bar = false,
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = false,
    font = wezterm.font("UbuntuSansMono Nerd Font", { weight = "Medium" }),
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    background = {
        {
            source = {
                Color = "#000000",
            },
            width = "100%",
            height = "100%",
            opacity = 0.82,
        },
    },
    -- from: https://akos.ma/blog/adopting-wezterm/
    hyperlink_rules = {
        -- Matches: a URL in parens: (URL)
        {
            regex = "\\((\\w+://\\S+)\\)",
            format = "$1",
            highlight = 1,
        },
        -- Matches: a URL in brackets: [URL]
        {
            regex = "\\[(\\w+://\\S+)\\]",
            format = "$1",
            highlight = 1,
        },
        -- Matches: a URL in curly braces: {URL}
        {
            regex = "\\{(\\w+://\\S+)\\}",
            format = "$1",
            highlight = 1,
        },
        -- Matches: a URL in angle brackets: <URL>
        {
            regex = "<(\\w+://\\S+)>",
            format = "$1",
            highlight = 1,
        },
        -- Then handle URLs not wrapped in brackets
        {
            -- Before
            --regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
            --format = '$0',
            -- After
            regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)",
            format = "$1",
            highlight = 1,
        },
        -- implicit mailto link
        {
            regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
            format = "mailto:$0",
        },
    },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_domain = 'WSL:Ubuntu-24.04'
    config.window_decorations = "RESIZE | TITLE"
    config.font_size = 13.5
    config.max_fps = 144
    config.enable_kitty_graphics = true
    config.use_ime = false
else
    config.font_size = 17.5
    config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
end

-- { key = 'n', mods = mod.SUPER, action = act.SpawnCommandInNewWindow { cwd = wezterm.home_dir, domain = 'DefaultDomain' } },

return config

