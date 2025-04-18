return {
    'fei6409/log-highlight.nvim',
    event = "VeryLazy",
    lazy = true,
    config = function()
        require('log-highlight').setup {}
    end,
}
