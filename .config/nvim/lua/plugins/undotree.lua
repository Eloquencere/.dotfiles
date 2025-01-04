return {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = function ()
        local keymap = vim.keymap
        keymap.set(
            "n",
            "<leader>ut",
            ":lua require('undotree').toggle()<cr>",
            { desc = "Toggle undotree"}
        )
    end,
}
