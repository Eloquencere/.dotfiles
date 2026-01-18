return {
    {
        "williamboman/mason.nvim",
        event = { "VeryLazy" },
        lazy = true,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "VeryLazy" },
        lazy = true,
        vim.diagnostic.config({
            virtual_text = { current_line = true }
        }),
        opts = {
            ensure_installed = {
                "lua_ls",
                "html",
                "jedi_language_server", -- Python
                "clangd", -- C, C++
                "biome", -- Javascript, Typescript, JSON
                "cssls",
                "marksman", -- Markdown
                "bashls", -- Bash, Zsh
                -- "svls", -- good, but needs a lot of config
                -- "vhdl_ls",
                "perlnavigator",
                -- "julials", -- Julia - causing issues
                "rust_analyzer",
                "gopls", -- Go
                "zls", -- Zig
                "yamlls",
                "dockerls",
                "taplo", -- TOML
                "neocmake",
                -- TCL - N/A
                -- Gitignore - N/A
                -- KDL - N/A
                -- Make - N/A
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "VeryLazy" },
        lazy = true,

        -- vim.lsp.config("svls", {
        --     filetypes = { "verilog", "systemverilog" },
        -- }),
        keys = {
            {
                mode = "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                { desc = "Rename variables or functions" }
            },
            {
                mode = "n",
                "<leader>rs",
                ":LspRestart<CR>",
                { desc = "Restart the LSP" }
            },
            {
                mode = "n",
                "K",
                vim.lsp.buf.hover,
                { desc = "Give details of text below cursor" }
            },
            {
                mode = "n",
                "<leader>gd",
                vim.lsp.buf.definition,
                { desc = "Go to definition" }
            },
            {
                mode = "n",
                "<leader>gi",
                vim.lsp.buf.implementation,
                { desc = "Go to implementation" }
            },
            {
                mode = "n",
                "<leader>gr",
                require("telescope.builtin").lsp_references,
                { desc = "Go to references" }
            },
            {
                mode = "n",
                "<leader>ca",
                vim.lsp.buf.code_action,
                { desc = "Perform code actions [Attached to telescope]" }
            },
        },
    },
}

