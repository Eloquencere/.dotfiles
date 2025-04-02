return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufEnter" },
    lazy = true,
    main = "ibl",
    config = function()
        require("ibl").setup({
            indent = { char = "│", highlight = highlight }, -- Solid Line
            -- indent = { char = "┊", highlight = highlight }, -- Dotted Line
        })
    end,
}
