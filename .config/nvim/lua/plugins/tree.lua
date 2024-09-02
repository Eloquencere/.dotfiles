return {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local nvimtree = require("nvim-tree")

        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            disable_netrw = true,
            hijack_cursor = true,
            sync_root_with_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            view = {
                width = 30,
                relativenumber = true,
                preserve_window_proportions = true,
            },
            renderer = {
                highlight_git = true,
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "", -- Arrow when folder is closed
                            arrow_open = "", -- Arrow when folder is open
                        },
                    },
                },
            },
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
            filters = {
                custom = { ".DS_Store" },
            },
            git = {
                ignore = false,
            },
        })

        -- Setting Keymaps
        local keymap = vim.keymap

        keymap.set(
            "n",
            "<leader>ee",
            "<cmd>NvimTreeToggle<CR>",
            { desc = "Toggle file explorer" }
        )

        keymap.set(
            "n",
            "<leader>ef",
            "<cmd>NvimTreeFindFileToggle<CR>",
            { desc = "Toggle file explorer on current file" }
        )

        keymap.set(
            "n",
            "<leader>ec",
            "<cmd>NvimTreeCollapse<CR>",
            { desc = "Collapse file explorer" }
        )
        keymap.set(
            "n",
            "<leader>er",
            "<cmd>NvimTreeRefresh<CR>",
            { desc = "Refresh file explorer" }
        )
    end
}
