return {
    "nat-418/boole.nvim",
    event = 'VeryLazy',
    lazy = true,
    config = function()
        require('boole').setup({
            mappings = {
                increment = '<C-a>',
                decrement = '<C-x>'
            },
            -- User defined loops
            additions = {
                { 'up', 'down' },
                { 'top', 'bottom' },
                { 'right', 'left' },
            },
            allow_caps_additions = {
                {'enable', 'disable'}
                -- enable → disable
                -- Enable → Disable
                -- ENABLE → DISABLE
            }
        })
    end,
}

