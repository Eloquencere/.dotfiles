return {
    "nat-418/boole.nvim",
    event = 'VeryLazy',
    lazy = true,

    config = function()
        boole = require('boole').setup({
            mappings = {
                increment = '<C-a>',
                decrement = '<C-x>'
            },
            -- User defined loops
            additions = {
                { 'up', 'down' },
                { 'top', 'bottom' },
                { 'right', 'left' },
                { 'input', 'output' }
            },
            allow_caps_additions = {
                {'enable', 'disable'}
            }

        })
    end,
}

