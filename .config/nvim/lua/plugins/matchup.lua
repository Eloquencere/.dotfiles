return {
    "andymass/vim-matchup",
    lazy = true,
    ft = { "systemverilog", "verilog", "vhdl" },
    init = function()
       vim.g.matchup_matchparen_enabled = 1
       vim.g.matchup_matchparen_offscreen = { method = 'popup' }
       vim.g.matchup_matchparen_deferred = 0
       vim.g.matchup_matchparen_timeout = 50
       vim.g.matchup_surround_enabled = 1
    end,
}
