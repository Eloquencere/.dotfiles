return {
    "lukas-reineke/indent-blankline.nvim", main = "ibl",
    event = "BufEnter",
    lazy = true,
    config = function()
        vim.wo.colorcolumn = "99999"

        require("ibl").setup({
            debounce = 100,
            indent = {
                char = "│",
                -- highlight = {
                --     "RainbowRed",
                --     "RainbowYellow",
                --     "RainbowBlue",
                --     "RainbowOrange",
                --     "RainbowGreen",
                --     "RainbowViolet",
                --     "RainbowCyan",
                -- },
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
                include = {
                    node_type = {
                        ["*"] = {
                            "class",
                            "function",
                            "method",
                            "block",
                            "if_statement",
                            "else_clause",
                            "for_statement",
                            "while_statement",
                            "try_statement",
                            "catch_clause",
                            "import_statement",
                            "jsx_element",
                            "jsx_self_closing_element",
                            "return",
                            "arguments",
                            "object",
                            "table",
                            "operation_type",
                        },
                    },
                },
                exclude = {
                    -- filetypes = {
                    --     "help",
                    --     "dashboard",
                    -- },
                    -- buftypes = { "terminal", "nofile" },
                },
            },
        })
        
    end,
}

