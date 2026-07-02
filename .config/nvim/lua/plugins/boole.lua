return {
    "nat-418/boole.nvim",
    event = 'VeryLazy',
    lazy = true,
    opts = {
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
            -- enable → disable
            -- Enable → Disable
            -- ENABLE → DISABLE
        }
    }
}

