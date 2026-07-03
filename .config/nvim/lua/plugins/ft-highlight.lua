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
    config = function()
        local function set_highlights()
            vim.api.nvim_set_hl(0, "FTHighlightFirst", {
                fg = "#00FF87",
                bold = true,
            })
            vim.api.nvim_set_hl(0, "FTHighlightSecond", {
                fg = "#FFB347",
                bold = true,
            })
            vim.api.nvim_set_hl(0, "FTHighlightThird", {
                fg = "#FF6B6B",
                bold = true,
            })
            vim.api.nvim_set_hl(0, "FTHighlightDimmed", {
                fg = "#6C6C6C",
            })
        end

        set_highlights()

        -- Re-apply on colorscheme changes
        vim.api.nvim_create_augroup("FtHighlightCustom", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = "FtHighlightCustom",
            callback = set_highlights,
        })

        -- The plugin's maybe_initialize() runs once on first f/F/t/T press
        -- and overwrites our highlights with its defaults. Defer to catch it.
        vim.defer_fn(set_highlights, 500)
    end,
}
