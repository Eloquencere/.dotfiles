return {
    'romgrk/barbar.nvim',
    event = { "VeryLazy" },
    lazy = true,
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- File icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
        vim.api.nvim_create_autocmd('QuitPre', {
            callback = function(tbl)
                local name = vim.api.nvim_buf_get_name(tbl.buf)
                if name ~= '' then
                    vim.api.nvim_command('BufferClose ' .. name)

                end
            end,
            group = vim.api.nvim_create_augroup('barbar_close_buf', {})
        })
    end,
    opts = {},
}
