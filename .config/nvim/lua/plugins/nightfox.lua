return { 
    "EdenEast/nightfox.nvim",
    init = function()
        require('nightfox').setup({
            options = {
                transparent = true
            }
        })
        vim.cmd("colorscheme carbonfox")
    end
}

