return {
    "declancm/cinnamon.nvim",
    version = "*", -- use latest release
    opts = {
        keymaps = {
            basic = true,
            extra = true,
        },
        -- Only scroll the window
        options = { mode = "cursor" },
    },
}
