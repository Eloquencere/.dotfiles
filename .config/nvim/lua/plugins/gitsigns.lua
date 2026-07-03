return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    lazy = true,

    config = function()
        require('gitsigns').setup({
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                -- Navigation
                vim.keymap.set('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({']c', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { buffer = bufnr })

                vim.keymap.set('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { buffer = bufnr })

                -- Actions
                vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { buffer = bufnr })
                vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { buffer = bufnr })
                vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, { buffer = bufnr })
                vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { buffer = bufnr })
                vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis('~') end, { buffer = bufnr })
                vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted, { buffer = bufnr })

                -- Text object
                vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr })
            end
        })
    end,
}
