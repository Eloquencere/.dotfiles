return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",

    init = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,

    opts = {
        provider_selector = function()
            -- Use treesitter for supported filetypes, fallback to indent
            return { "treesitter", "indent" }
        end,
    }
}

