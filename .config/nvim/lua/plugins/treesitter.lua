-- Neovim's built-in ftplugins for some filetypes add *buffer-local* [m/[M/[[/]]/]m/]M/][/[]
-- jumps (regex based, e.g. python's Python_jump). Buffer-local mappings beat global ones, which
-- would shadow the treesitter textobjects mapped below for the whole of that filetype.
-- Turn them off where treesitter has a real replacement; vhdl and markdown keep theirs because
-- treesitter textobjects have no equivalent there (design units / headings).
vim.g.no_python_maps = 1
vim.g.no_go_maps = 1
vim.g.no_rust_maps = 1

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
                -- select the next textobject when the cursor sits just before it
                lookahead = true,
            },
            move = {
                -- put jumps in the jumplist
                set_jumps = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter-textobjects").setup(opts)

            -- NOTE: the `main` branch does not create keymaps from `setup()` any more -- only
            -- `select.{lookahead,lookbehind,selection_modes,include_surrounding_whitespace}` and
            -- `move.set_jumps` are read. Captures have to be mapped with the module API, which is
            -- what the two tables below do (the master-branch `keymaps`/`goto_next_start = {...}`
            -- shape is silently ignored on main).

            local ts_move = require("nvim-treesitter-textobjects.move")
            local ts_select = require("nvim-treesitter-textobjects.select")

            -- select in visual + operator-pending mode, e.g. `vif`, `daf`
            -- { lhs, capture, description [, query group] }
            local selects = {
                { "ii", "@conditional.inner", "conditional inner" },
                { "ai", "@conditional.outer", "conditional outer" },
                { "il", "@loop.inner", "loop inner" },
                { "al", "@loop.outer", "loop outer" },
                { "ib", "@block.inner", "block inner" },
                { "ab", "@block.outer", "block outer" },
                { "if", "@function.inner", "function inner" },
                { "af", "@function.outer", "function outer" },
                { "ic", "@class.inner", "class inner" },
                { "ac", "@class.outer", "class outer" },
                { "as", "@local.scope", "language scope", "locals" },
            }
            for _, select in ipairs(selects) do
                local lhs, capture, what, group = unpack(select)
                vim.keymap.set({ "x", "o" }, lhs, function()
                    ts_select.select_textobject(capture, group)
                end, { desc = "Select " .. what })
            end

            -- move in normal/visual/operator-pending mode, e.g. `]m`, `y]m`
            -- { lhs, move, capture, description [, query group] }
            local moves = {
                { "]m", "goto_next_start", "@function.outer", "Next function start" },
                { "]]", "goto_next_start", "@class.outer", "Next class start" },
                { "]o", "goto_next_start", { "@loop.inner", "@loop.outer" }, "Next loop start" },
                { "]s", "goto_next_start", "@local.scope", "Next scope", "locals" },
                { "]z", "goto_next_start", "@fold", "Next fold", "folds" },
                { "]M", "goto_next_end", "@function.outer", "Next function end" },
                { "][", "goto_next_end", "@class.outer", "Next class end" },
                { "[m", "goto_previous_start", "@function.outer", "Previous function start" },
                { "[[", "goto_previous_start", "@class.outer", "Previous class start" },
                { "[M", "goto_previous_end", "@function.outer", "Previous function end" },
                { "[]", "goto_previous_end", "@class.outer", "Previous class end" },
                { "]d", "goto_next", "@conditional.outer", "Next conditional" },
                { "[d", "goto_previous", "@conditional.outer", "Previous conditional" },
            }
            for _, move in ipairs(moves) do
                local lhs, mover, capture, what, group = unpack(move)
                vim.keymap.set({ "n", "x", "o" }, lhs, function()
                    ts_move[mover](capture, group)
                end, { desc = what })
            end

            -- f/F/t/T and the `;`/`,` repeats, via repeatable_move
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
