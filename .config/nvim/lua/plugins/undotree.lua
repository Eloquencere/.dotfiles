return {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    lazy = true,

    opts = {},
    keys = {
        {
            "<Leader>u",
            function() require("undotree").toggle() end,
            { desc = "Undotree: toggle" },
        },
    },
}

