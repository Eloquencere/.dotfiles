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
            highlight = { enable = true },
            indent = { enable = true },
            autotag = { enable = true },
            -- Ensure these Language Parsers are Installed
            ensure_installed = {
                "json", "yaml",
                "javascript", "typescript", "tsx",
                "html", "css",
                "markdown", "markdown_inline",
                "bash", "tcl",
                "vhdl",
                "lua", "perl", "julia", "matlab",
                "c", "cpp", "rust", "go", "python", "zig",
                "gitignore", "dockerfile", "toml", "diff", "regex", "kdl",
                "cmake", "make", "just", "sql",
                "doxygen",
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
