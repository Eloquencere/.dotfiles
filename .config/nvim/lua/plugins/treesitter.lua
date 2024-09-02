return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- Import treesitter configuration
        local treesitter = require("nvim-treesitter.configs")

        -- Configure treesitter
        treesitter.setup({
            highlight = {
                enable = true,
            },
            -- Enable Indentation
            indent = { enable = true },
            -- Enable Autotagging
            autotag = {
                enable = true,
            },
            -- Ensure these Language Parsers are Installed
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "yaml",
                "html",
                "css",
                "prisma",
                "markdown",
                "markdown_inline",
                "svelte",
                "graphql",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "query",
                "vimdoc",
                "c",
                "cpp",
                "doxygen",
                "gitignore",
                "verilog",
                "python",
                "rust",
                "perl",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
