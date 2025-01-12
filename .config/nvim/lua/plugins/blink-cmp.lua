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

        completion = {
            menu = {
                auto_show = false,
            },
        },

        keymap = {
            preset = 'none',
            ['<C-p>'] = { 'show' },
            ['<C-p>'] = { 'select_prev' },
            ['<C-Tab>'] = { 'select_next' },
        },
    },
    opts_extend = { "sources.default" }
}

