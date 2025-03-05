return {
    'jinh0/eyeliner.nvim',
    config = function()
        require'eyeliner'.setup {
            highlight_on_key = true,
            dim = true,             
            max_length = 9999,
            disabled_filetypes = {},
            default_keymaps = true,
        }
    end
}

