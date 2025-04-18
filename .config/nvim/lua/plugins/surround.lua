return {
    "kylechui/nvim-surround", version = "*",
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("nvim-surround").setup({
        })
    end
}
