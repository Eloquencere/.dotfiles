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

        keymap = {
            ['<C-p>'] = { 'show' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<Tab>'] = { 'snippet_forward', 'fallback' },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        },
    },
    opts_extend = { "sources.default" }
}

