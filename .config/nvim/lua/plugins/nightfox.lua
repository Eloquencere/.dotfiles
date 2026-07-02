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
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("override_matchparen", { clear = true }),
            callback = function()
                vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffbf00" })
            end,
        })
    end
}

