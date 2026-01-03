return {
    "EdenEast/nightfox.nvim",
    priority = 1000, -- Ensure it loads first
    init = function()
        require('nightfox').setup({
            options = {
                transparent = true
            }
        })

        vim.cmd("colorscheme carbonfox")
        vim.cmd("highlight MatchParen guifg=#ffbf00") -- Needs to be initialised after changing scheme
    end
}
