return {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require('undotree').setup()
    end,
    keys = {
        {
            "<Leader>u",
            function()
                require("undotree").toggle()
            end,
            { desc = "Undotree: toggle" },
        },
    },
}

