return {
    "elanmed/ft-highlight.nvim",
    event = "VeryLazy",
    lazy = true,
    init = function()
        vim.g.ft_highlight = {
            -- A string pattern to determine if a character should be highlighted
            -- according to its occurrence. Defaults to "." (matches every character).
            highlight_pattern = ".",
        }
    end,
    keys = {
        {
            "f",
            "<Plug>FtHighlight_f",
            desc = "ft-highlight f",
            mode = { "n", "v", "o" },
            remap = true,
        },
        {
            "F",
            "<Plug>FtHighlight_F",
            desc = "ft-highlight F",
            mode = { "n", "v", "o" },
            remap = true,
        },
        {
            "t",
            "<Plug>FtHighlight_t",
            desc = "ft-highlight t",
            mode = { "n", "v", "o" },
            remap = true,
        },
        {
            "T",
            "<Plug>FtHighlight_T",
            desc = "ft-highlight T",
            mode = { "n", "v", "o" },
            remap = true,
        },
    },
}
