return {
    "brenoprata10/nvim-highlight-colors",
    opts = {
        render = "background",
        virtual_symbol = "■",
        enable_named_colors = true,
        enable_tailwind = true,
        exclude_filetypes = {
            'systemverilog', 'verilog',
        },
    },
    event = { "BufReadPost", "BufNewFile" },
}
