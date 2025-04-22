return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    lazy = true,
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
                disable = { "verilog", "systemverilog" }
            },
            indent = { enable = true },
            autotag = { enable = true },
            -- Ensure these Language Parsers are Installed
            ensure_installed = {
                "javascript", "typescript", "tsx",
                "html", "css",
                "markdown", "markdown_inline",
                "bash", "tcl",
                "vhdl", "verilog",
                "lua", "perl", "julia",
                "c", "cpp", "rust", "go", "python", "zig",
                "json", "yaml",
                "gitignore", "dockerfile", "toml", "kdl",
                "cmake", "make", -- "just",
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
