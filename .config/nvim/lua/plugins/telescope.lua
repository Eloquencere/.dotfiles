return {
    {
        "nvim-telescope/telescope.nvim",
        event = { "VeryLazy" },
        lazy = true,
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
            "folke/todo-comments.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local transform_mod = require("telescope.actions.mt").transform_mod

            telescope.setup({
                defaults = {
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                        },
                    },
                },
            })

            telescope.load_extension("fzf")

            -- Setting keymaps
            local keymap = vim.keymap
            keymap.set(
                "n",
                "<leader>ff",
                "<cmd>Telescope find_files<cr>",
                { desc = "Fuzzy find files in cwd" }
            )

            keymap.set(
                "n",
                "<leader>fr",
                "<cmd>Telescope oldfiles<cr>",
                { desc = "Fuzzy find recent files" }
            )

            keymap.set(
                "n",
                "<leader>fs",
                "<cmd>Telescope live_grep<cr>",
                { desc = "Find string in cwd" }
            )

            keymap.set(
                "n",
                "<leader>fc",
                "<cmd>Telescope grep_string<cr>",
                { desc = "Find string under cursor in cwd" }
            )

            keymap.set(
                "n",
                "<leader>ft",
                "<cmd>TodoTelescope<cr>",
                { desc = "Find todos" }
            )

            keymap.set(
                {"n", "i"},
                "z=",
                "<cmd>Telescope spell_suggest<cr>",
                { desc = "Spell Suggestions"}
            )

            keymap.set(
                "n",
                "<leader>fk",
                "<cmd>Telescope keymaps<cr>",
                { desc = "Keymaps" }
            )

            keymap.set(
                "n",
                "<leader>tt",
                "<cmd>Telescope buffers sort_mru=true<cr>",
                { desc = "Display opened buffers" }
            )

            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        event = { "VeryLazy" },
        lazy = true,
    }
}
