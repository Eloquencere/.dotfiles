return {
    'romgrk/barbar.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons', -- File icons
    },

    lazy = true,

    init = function()
        vim.g.barbar_auto_setup = false
    end,

    config = function()
        require('barbar').setup()

        -- Moving between buffers
        vim.keymap.set(
            {"n", "i", "v"},
            '<C-Tab>',
            '<Cmd>BufferNext<CR>',
            { noremap = true, silent = true, desc = "Move to next buffer" }
        )
        vim.keymap.set(
            {"n", "i", "v"},
            '<C-S-Tab>',
            '<Cmd>BufferPrevious<CR>',
            { noremap = true, silent = true, desc = "Move to previous buffer" }
        )

        -- Close variants
        vim.keymap.set('n', '<leader>bc', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
        vim.keymap.set('n', '<leader>bC', '<Cmd>BufferCloseAllButCurrent<CR>', { desc = 'Close all but current' })

        -- Restore last closed
        vim.keymap.set('n', '<leader>br', '<Cmd>BufferRestore<CR>', { desc = 'Restore last closed buffer' })

        -- Move tabs manually (also works via mouse drag)
        vim.keymap.set('n', '<leader>b<', '<Cmd>BufferMovePrevious<CR>', { desc = 'Move tab left' })
        vim.keymap.set('n', '<leader>b>', '<Cmd>BufferMoveNext<CR>', { desc = 'Move tab right' })

        -- Pin/unpin
        vim.keymap.set('n', '<leader>bn', '<Cmd>BufferPin<CR>', { desc = 'Pin/unpin buffer' })

        -- -- Buffer picking (visual tab selection)
        -- vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPick<CR>', { desc = 'Pick buffer' })
        -- vim.keymap.set('n', '<leader>bd', '<Cmd>BufferPickDelete<CR>', { desc = 'Pick buffers to delete' })
    end,
}

