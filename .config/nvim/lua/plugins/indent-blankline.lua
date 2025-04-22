return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufEnter",
    lazy = true,
    main = "ibl",

    opts = {
        scope = { enabled = false }
    },

    config = function()
        require("ibl").setup({
            indent = { char = "│", highlight = highlight },
            -- indent = { char = "┊", highlight = highlight },
        })
    end,
}

