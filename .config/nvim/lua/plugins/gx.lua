return {
    "chrishrb/gx.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        {
            mode = { "n", "x" },
            "gx",
            "<cmd>Browse<cr>",
        }
    },
    cmd = { "Browse" },
    init = function()
        vim.g.netrw_nogx = 1
    end,
    config = true,
    -- default settings
    submodules = false, -- not needed, submodules are required only for tests
}
