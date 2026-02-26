return {
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            "williamboman/mason.nvim",
        },
        -- can't be lazy loaded
        opts = {
            ensure_installed = {
                -- language servers
                "clangd", -- C, C++
                "neocmakelsp",
                "zls", -- Zig
                "rust-analyzer",
                "gopls", -- Go
                "bash-language-server", -- Bash, Zsh
                "perlnavigator",
                "lua-language-server",
                "jedi-language-server", -- Python
                "julia-lsp",
                "html-lsp",
                "css-lsp",
                "marksman", -- Markdown
                "biome", -- Javascript, Typescript, JSON
                "docker-language-server", -- Docker, Podman
                "yaml-language-server",
                "taplo", -- TOML
                "mbake", -- makefile
                "just-lsp",
                "tinymist", -- Typst
                -- "svls", -- good, but needs a lot of config
                -- "vhdl_ls", -- not needed at the moment
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = { "VeryLazy" },
        lazy = true,

        vim.diagnostic.config({
            virtual_text = { current_line = true }
        }),

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

