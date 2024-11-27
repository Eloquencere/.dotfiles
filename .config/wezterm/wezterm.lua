local wezterm = require("wezterm")
local config = require("config")
require("events")

-- Apply color scheme based on the WEZTERM_THEME environment variable
local themes = {
	nord = "Nord (Gogh)",
	onedark = "One Dark (Gogh)",
}
local success, stdout, stderr = wezterm.run_child_process({ os.getenv("SHELL"), "-c", "printenv WEZTERM_THEME" })
local selected_theme = stdout:gsub("%s+", "") -- Remove all whitespace characters including newline
config.color_scheme = themes[selected_theme]

-- Key mappings for tab movement in neovim, thanks to - reddit.com/r/neovim/comments/uc6q8h/ability_to_map_ctrl_tab_and_more/
config.keys = {
  -- Map Ctrl + Tab
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.SendString("\x1b[9;5u"), -- Custom escape sequence
  },
  -- Map Ctrl + Shift + Tab
  {
    key = "Tab",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SendString("\x1b[9;6u"), -- Custom escape sequence
  },
  -- -- Map Ctrl + Enter
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\x1b[13;2u"),
  },
}

return config
