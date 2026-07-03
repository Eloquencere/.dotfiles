return {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },

    init = function()
        vim.g.netrw_nogx = 1
    end,
    config = true,
    cmd = { "Browse" },
    keys = {
        {
            mode = { "n", "x" },
            "gx",
            "<CMD>Browse<CR>",
        }
    },
}
