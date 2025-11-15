local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("gui-startup", function()
    local _, _, window = wezterm.mux.spawn_window({})
    window:gui_window():maximize()
end)

config = {
    -- Initialisations
    check_for_updates = false,
    max_fps = 144,
    animation_fps = 30,
    color_scheme = "Aco",

    -- Window config
    window_decorations = "RESIZE",
    enable_tab_bar = false,
    adjust_window_size_when_changing_font_size = false,
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

    -- Text
    font = wezterm.font("UbuntuSansMono Nerd Font", { weight = "Medium" }),
    harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, -- disable ligatures
    font_size = 17.5,
    use_ime = false, -- Experimental
    default_cursor_style = "SteadyBar",

    -- Key mappings for tab movement in neovim, thanks to - reddit.com/r/neovim/comments/uc6q8h/ability_to_map_ctrl_tab_and_more/
    keys = {
        {
            key = "Tab",
            mods = "CTRL",
            action = wezterm.action.SendString("\x1b[9;5u"),
        },
        {
            key = "Tab",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SendString("\x1b[9;6u"),
        },
        {
            key = "Enter",
            mods = "SHIFT",
            action = wezterm.action.SendString("\x1b[13;2u"),
        },
    },

    table.insert(wezterm.default_hyperlink_rules(), {
        regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
        format = 'https://www.github.com/$1/$3',
    })
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_domain = 'WSL:Ubuntu-24.04'
    config.font_size = 13.5
    config.window_decorations = "RESIZE | TITLE"
end

return config

