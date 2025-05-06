return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    lazy = true,
    opts = {},
    init = function()
        vim.opt.matchpairs:append('<:>')
    end,
    config = function()
        local npairs = require("nvim-autopairs")
        local Rule = require('nvim-autopairs.rule')
        local cond   = require('nvim-autopairs.conds')
        local ts_conds = require('nvim-autopairs.ts-conds')

        npairs.setup({
            enable_check_bracket_line = true,
            map_cr = true,
            check_ts = true,
            ts_config = {
                lua = { 'string' },-- it will not add a pair on that treesitter node
                javascript = { 'template_string' },
                java = false,-- don't check treesitter on java
            }
        })

        -- Completion rules
        npairs.remove_rule('`')
        npairs.add_rules({
            Rule("$", "$", "lua")
                :with_pair(ts_conds.is_not_ts_node({'function'})),
            Rule(' ', ' ')
                :with_pair(function(opts)
                    -- Get two characters: before and after the cursor
                    local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
                    local next_char = opts.line:sub(opts.col, opts.col)

                    -- Check if you are between matching brackets with nothing inside
                    return (prev_char == '{' and next_char == '}')
                end),
        })
    end,
}

