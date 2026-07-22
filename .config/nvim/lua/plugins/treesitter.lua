return {
    {
        "romus204/tree-sitter-manager.nvim",
        opts = {
            highlight = true,
            ensure_installed = {
                "javascript", "typescript", "tsx",
                "html", "css",
                "markdown", "markdown_inline",
                "bash", "tcl",
                "vhdl", "systemverilog",
                "lua", "perl", "julia",
                "c", "cpp", "rust", "go", "python",
                "json", "yaml",
                "gitignore", "dockerfile", "toml", "kdl",
                "cmake", "make", "doxygen",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["ii"] = "@conditional.inner",
                    ["ai"] = "@conditional.outer",
                    ["il"] = "@loop.inner",
                    ["al"] = "@loop.outer",
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    ["]o"] = "@loop.*",
                    ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
                goto_next = { ["]d"] = "@conditional.outer" },
                goto_previous = { ["[d"] = "@conditional.outer" },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)

            local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
            vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move)
            vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_opposite)
            vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat.builtin_f_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat.builtin_F_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat.builtin_t_expr, { expr = true })
            vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat.builtin_T_expr, { expr = true })
        end,
    },
    -- Auto-closing tags (works standalone)
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
        opts = {},
    },
}

