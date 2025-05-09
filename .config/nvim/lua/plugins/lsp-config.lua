return {
    {
        "williamboman/mason.nvim",
        event = { "VeryLazy" },
        lazy = true,
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "VeryLazy" },
        lazy = true,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", -- Lua
                    "html", -- HTML
                    "jedi_language_server", -- Python
                    "clangd", -- C, C++
                    "biome", -- Javascript, Typescript, JSON
                    "cssls", -- CSS
                    "marksman", -- Markdown
                    "bashls", -- Bash, Zsh
                    "svlangserver",
                    "verible", -- SV
                    "vhdl_ls", -- VHDL
                    "perlnavigator", -- Perl
                    "julials", -- Julia
                    "rust_analyzer", -- Rust
                    "gopls", -- Go
                    "zls", -- Zig
                    "yamlls", -- YAML
                    "dockerls", -- Dockerfile
                    "taplo", -- TOML
                    "neocmake", -- CMake
                }
                -- TCL - N/A
                -- Gitignore - N/A
                -- KDL - N/A
                -- Make - N/A
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = { "VeryLazy" },
        lazy = true,
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({})
            lspconfig.html.setup({})
            lspconfig.jedi_language_server.setup({})
            lspconfig.clangd.setup({})
            lspconfig.biome.setup({})
            lspconfig.cssls.setup({})
            lspconfig.marksman.setup({})
            lspconfig.bashls.setup({})
            lspconfig.svlangserver.setup({})
            lspconfig.vhdl_ls.setup({})
            lspconfig.perlnavigator.setup({})
            lspconfig.julials.setup({})
            lspconfig.rust_analyzer.setup({})
            lspconfig.gopls.setup({})
            lspconfig.zls.setup({})
            lspconfig.yamlls.setup({})
            lspconfig.dockerls.setup({})
            lspconfig.taplo.setup({})
            lspconfig.neocmake.setup({})

            vim.diagnostic.config(
                {
                    virtual_text = { current_line = true }
                }
            )

            local keymap = vim.keymap

            keymap.set(
                "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                { desc = "Rename variables or functions" }
            )

            keymap.set(
                "n",
                "K",
                vim.lsp.buf.hover,
                { desc = "Give details of text below cursor" }
            )

            keymap.set(
                "n",
                "<leader>gd",
                vim.lsp.buf.definition,
                { desc = "Go to definition" }
            )

            keymap.set(
                "n",
                "<leader>gi",
                vim.lsp.buf.implementation,
                { desc = "Go to implementation" }
            )

            keymap.set(
                "n",
                "<leader>gr",
                require("telescope.builtin").lsp_references,
                { desc = "Go to references" }
            )

            keymap.set(
                "n",
                "<leader>ca",
                vim.lsp.buf.code_action,
                { desc = "Perform code actions [Attached to telescope]" }
            )
        end
    }
}
