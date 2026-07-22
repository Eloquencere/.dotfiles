local server_map = {
    clangd            = "clangd", -- C, C++
    neocmakelsp       = "neocmake", -- cmake
    ["rust-analyzer"] = "rust_analyzer",
    gopls             = "gopls",
    ["bash-language-server"] = "bashls",
    perlnavigator     = "perlnavigator",
    ["lua-language-server"]  = "lua_ls",
    pyrefly           = "pyrefly", -- Python
    ["julia-lsp"]     = "julials",
    ["html-lsp"]      = "html",
    ["css-lsp"]       = "cssls",
    marksman          = "marksman", -- Markdown
    biome             = "biome", -- Javascript, Typescript, JSON
    ["yaml-language-server"] = "yamlls",
    taplo             = "taplo", -- TOML
    mbake             = "mbake", -- makefile
    ["just-lsp"]      = "just",
    tinymist          = "tinymist",
    -- "svls", -- good, but needs a lot of config
    -- "vhdl_ls", -- not needed at the moment
}
return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},  -- triggers lazy.nvim's auto-config → require("mason").setup({})
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = {
            ensure_installed = vim.tbl_keys(server_map),
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",

        init = function()
            vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

            vim.diagnostic.config({
                virtual_text = { current_line = true },
            })
        end,

        config = function()
            for _, server in ipairs(vim.tbl_values(server_map)) do
                vim.lsp.config(server, {})  -- override any broken lspconfig registration
            end

            vim.lsp.config("xilinx", {
                cmd = { "xilinx-language-server" },
                filetypes = { "xdc", "xsct", "tcl" },
                root_markers = { ".git" },
                init_options = {
                    method = "builtin",
                },
            })
            vim.lsp.config("mbake", {
                cmd = { "mbake" },
                filetypes = { "makefile", "make" },
                root_markers = { ".git", "Makefile" },
            })

            vim.lsp.enable(vim.tbl_values(server_map))
        end,

        keys = {
            {
                mode = "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                desc = "Rename variables or functions",
            },
            {
                mode = "n",
                "<leader>rs",
                ":LspRestart<CR>",
                desc = "Restart the LSP",
            },
            {
                mode = "n",
                "K",
                vim.lsp.buf.hover,
                desc = "Give details of text below cursor",
            },
            {
                mode = "n",
                "<leader>gd",
                vim.lsp.buf.definition,
                desc = "Go to definition",
            },
            {
                mode = "n",
                "<leader>gi",
                vim.lsp.buf.implementation,
                desc = "Go to implementation",
            },
            {
                mode = "n",
                "<leader>gr",
                function() require("telescope.builtin").lsp_references() end,
                desc = "Go to references",
            },
            {
                mode = "n",
                "<leader>ca",
                vim.lsp.buf.code_action,
                desc = "Perform code actions",
            },
        },
    },
}
