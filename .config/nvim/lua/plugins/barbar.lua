return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
        vim.g.barbar_auto_setup = false
        vim.api.nvim_create_autocmd('WinClosed', {
          callback = function(tbl)
            local name = vim.api.nvim_buf_get_name(tbl.buf)
            if name ~= '' then
              vim.api.nvim_command('BufferClose ' .. name)
            end
          end,
          group = vim.api.nvim_create_augroup('barbar_close_buf', {})
        })
    end,
    opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        -- animation = true,
        -- insert_at_start = true,
        -- …etc.
        sidebar_filetypes = {
            -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
            NvimTree = true,
            -- Or, specify the text used for the offset:
            undotree = {
                text = 'undotree',
                align = 'center', -- *optionally* specify an alignment (either 'left', 'center', or 'right')
            },
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    }
}
