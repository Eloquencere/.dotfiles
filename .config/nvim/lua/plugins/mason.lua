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
                "clangd", -- C, C++
                "neocmake",
                "zls", -- Zig
                "rust_analyzer",
                "gopls", -- Go
                "bashls", -- Bash, Zsh
                "perlnavigator",
                "lua_ls",
                "jedi_language_server", -- Python
                "html",
                "cssls",
                "marksman", -- Markdown
                "biome", -- Javascript, Typescript, JSON
                "yamlls",
                "taplo", -- TOML
                "dockerls", -- Docker, Podman
                -- "mbake", -- makefile (correct, but not recognized for some reason)
                "just",
                "bacon_ls",
                -- "svls", -- good, but needs a lot of config
                -- "julials", -- causing issues
                -- "vhdl_ls",
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

        vim.lsp.config("xilinx", {
            cmd = { "xilinx-language-server" },
            filetypes = { "xdc", "xsct", "tcl" },
            root_markers = { ".git" },
            init_options = {
                method = "builtin",
            },
        }),

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

