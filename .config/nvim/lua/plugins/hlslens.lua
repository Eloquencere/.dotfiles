return {
    "kevinhwang91/nvim-hlslens",
    event = "VeryLazy",
    lazy = true,
    init = function()
        require("hlslens").setup({
            nearest_only = true
        })
    end,
    -- Probably have to configure further to integrate with nvim-ufo
    keys = {
        {
            "n",
            [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
        },
        {
            "N",
            [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]],
        },
        { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
        { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
        { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
        { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
        { "<ESC>", [[<cmd>noh<CR><cmd>lua require('hlslens').stop()<CR>]] },
    },
}

