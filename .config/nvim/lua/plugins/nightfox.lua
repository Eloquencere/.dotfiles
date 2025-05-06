return {
    "EdenEast/nightfox.nvim",
    event = "VeryLazy",
    lazy = true,
    init = function()
        require('nightfox').setup({
            options = {
                transparent = true
            }
        })

        vim.cmd("colorscheme carbonfox")
        vim.cmd("highlight MatchParen guifg=#ffbf00")
    end
}

