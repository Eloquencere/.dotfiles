return {
    "andymass/vim-matchup",
    setup = function()
        vim.g.matchup_matchparen_enabled = 0
        vim.g.matchup_matchparen_offscreen = {}
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_timeout = 100
        vim.g.matchup_surround_enabled = 1
        -- vim.g.matchup_text_obj_linewise_operators = ['d', 'y', 'c']
    end,
}
