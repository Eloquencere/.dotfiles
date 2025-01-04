return {
    "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },

    config = function()
        -- Setting Keymaps
        local keymap = vim.keymap

        keymap.set(
            "n",
            "<C-n>",
            "<cmd>Neotree<CR>",
            { desc = "Toggle file explorer" }
        )
    end
}
