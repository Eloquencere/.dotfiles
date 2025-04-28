return {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
    init = function()
        vim.g.netrw_nogx = 1
    end,
    cmd = { "Browse" },
    keys = {
        {
            mode = { "n", "x" },
            "gx",
            "<CMD>Browse<CR>",
        }
    },
}
