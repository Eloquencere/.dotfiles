return {
    'mfussenegger/nvim-lint',
    event = {
        'BufReadPre',
        'BufNewFile',
        'BufWritePost',
        'TextChanged',
        'InsertLeave'
    },
    config = function()
        local lint = require('lint')

        local verilator = lint.linters.verilator

        verilator = {
            cmd = "verilator",
            args = {
                "--lint-only", "-sv",

                "-Wall", "-Wpedantic",
                "-Wno-DECLFILENAME",

                "--bbox-sys",
                "--bbox-unsup",

                -- -- You can also use or re-use a verilator.f file (see example\verilator.f)
                -- -- placed anywhere between CWD and your home dir and it
                -- -- will be read by Verilator
                -- '-f',
                -- vim.fs.find('verilator.f', {upward = true, stop = vim.env.HOME})[1],
            }
        }

        lint.linters_by_ft = {
            systemverilog = { 'verilator' },
            verilog       = { 'verilator' },
        }

        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
            group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
            callback = function()
                vim.defer_fn(function()
                    lint.try_lint()
                end, 1)
            end,
        })
    end
}

