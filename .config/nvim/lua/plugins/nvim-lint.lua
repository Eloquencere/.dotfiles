return {
    'mfussenegger/nvim-lint',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require('lint')

        lint.linters_by_ft = {
            systemverilog = { 'verilator' },
            verilog       = { 'verilator' },
        }

        local verilator = lint.linters.verilator

        verilator.args = {
            "--lint-only",
            "--timing",
             "-sv",

            "-Wall", "-Wpedantic",
            "-Wno-DECLFILENAME",
            "-Wno-PINCONNECTEMPTY",
            -- "-Wno-NOTFOUNDMODULE", -- Not a feature yet

            "--bbox-sys",
            "--bbox-unsup",

            -- You can also use or re-use a verilator.f file (see example\verilator.f)
            -- placed anywhere between CWD and your home dir and it
            -- will be read by Verilator
            -- '-f',
            -- vim.fs.find('verilator.f', {upward = true, stop = vim.env.HOME})[1],
        }

        local lint_autogroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
          group = lint_autogroup,
          callback = function()
            lint.try_lint()
          end,
        })
    end
}

