return {
    "kylechui/nvim-surround", version = "^3.0.0",
    event = "VeryLazy",
    lazy = true,
    config = function()
        vim.keymap.set(
            { 'n', 'v' },
            's',
            '<Nop>',
            { desc = "Unsetting it to allow for surround to work" }
        )

        require("nvim-surround").setup({
            keymaps = {
                normal = "s",
                normal_cur = "ss",
                normal_cur_line = "ssa",
                delete = "ds",
                change = "cs",
                change_line = "css",
                visual = "s",
                visual_line = "s",
            }
            -- surrounds = {
            --     ["("] = {
            --         add = { "(", ")" },
            --         find = function()
            --             return M.get_selection({ motion = "a(" })
            --         end,
            --         delete = "^(. ?)().-( ?.)()$",
            --     },
            --     [")"] = {
            --         add = { "( ", " )" },
            --         find = function()
            --             return M.get_selection({ motion = "a)" })
            --         end,
            --         delete = "^(.)().-(.)()$",
            --     },
            --     ["{"] = {
            --         add = { "{", "}" },
            --         find = function()
            --             return M.get_selection({ motion = "a{" })
            --         end,
            --         delete = "^(. ?)().-( ?.)()$",
            --     },
            --     ["}"] = {
            --         add = { "{ ", " }" },
            --         find = function()
            --             return M.get_selection({ motion = "a}" })
            --         end,
            --         delete = "^(.)().-(.)()$",
            --     },
            --     ["<"] = {
            --         add = { "<", ">" },
            --         find = function()
            --             return M.get_selection({ motion = "a<" })
            --         end,
            --         delete = "^(. ?)().-( ?.)()$",
            --     },
            --     [">"] = {
            --         add = { "< ", " >" },
            --         find = function()
            --             return M.get_selection({ motion = "a>" })
            --         end,
            --         delete = "^(.)().-(.)()$",
            --     },
            --     ["["] = {
            --         add = { "[", "]" },
            --         find = function()
            --             return M.get_selection({ motion = "a[" })
            --         end,
            --         delete = "^(. ?)().-( ?.)()$",
            --     },
            --     ["]"] = {
            --         add = { "[ ", " ]" },
            --         find = function()
            --             return M.get_selection({ motion = "a]" })
            --         end,
            --         delete = "^(.)().-(.)()$",
            --     },
            -- },
        })
    end
}

