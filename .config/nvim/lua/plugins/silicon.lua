return {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    config = function()
        require("silicon").setup({
            font = "JetBrainsMono Nerd Font=34;Noto Color Emoji=34"
        })
    end,
}
