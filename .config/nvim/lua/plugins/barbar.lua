return {
    'romgrk/barbar.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- File icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
        vim.api.nvim_create_autocmd('WinClosed', {
            callback = function(tbl)
                if vim.api.nvim_buf_is_valid(tbl.buf) then
                    vim.api.nvim_buf_delete(tbl.buf, { force = true })
                end
            end,
            group = vim.api.nvim_create_augroup('barbar_close_buf', {}),
        })
    end,
    opts = {},
}

