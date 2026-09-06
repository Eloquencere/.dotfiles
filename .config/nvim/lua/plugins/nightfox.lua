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
        -- MatchParen must be set after the scheme loads (the scheme resets it).
        -- lightblue bg + dark fg so the matching pair visibly lights up.
        vim.api.nvim_set_hl(0, "MatchParen", { bg = "#add8e6", fg = "#1f2430" })
    end
}

