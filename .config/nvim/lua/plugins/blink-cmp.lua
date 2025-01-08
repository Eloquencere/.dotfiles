return {
    enabled = false,

    'saghen/blink.cmp', version = '*',
    dependencies = { 'rafamadriz/friendly-snippets' },

    opts = {
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono'
        },

        keymap = { preset = 'default' },

        completion = {
            menu = {
                auto_show = false,
            },
        },
    },
    opts_extend = { "sources.default" }
}

