return {
    "kylechui/nvim-surround", version = "^3.0.0",
    event = "VeryLazy",
    lazy = true,
    config = function()
        require("nvim-surround").setup({
            keymaps = {
                normal = "s",
                normal_cur = "ss",
                normal_cur_line = "ssa",
                visual = "s",
                visual_line = "s",
                delete = "sd",
                change = "sr",
                change_line = "ssr",
            },
        })
    end
}

