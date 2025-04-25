local opt = vim.opt

-- Basic Settings
opt.number = true
opt.relativenumber = true
opt.clipboard:append("unnamedplus")

-- Tabs and Indentation
opt.tabstop = 4    -- Number of spaces a tab character takes up
opt.softtabstop = 4
opt.shiftwidth = 4 -- Amount of spaces ">>" & "<<" take up
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.formatoptions = tcqrn1
opt.wrap = false

-- Cursor motion
opt.matchpairs:append('<:>')
opt.cursorline = true

-- Intricate settings
opt.modelines = 0
opt.visualbell = true
opt.autochdir = true
opt.backspace = "indent,eol,start"
opt.showmode = false
opt.shortmess:append("S")

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Disabling syntax highlighting for .f files
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = { "*.f" },
        callback = function()
            vim.cmd("syntax off")
        end,
    }
)

-- Enabling syntax highlighting for verilog files
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" }, 
    {
        pattern = { "*.v" },
        callback = function()
            vim.cmd("setfiletype verilog")
        end,
    }
)

-- Setting comment strings
vim.api.nvim_create_autocmd(
    { "FileType" },
	{ 
	    pattern = { "verilog", "systemverilog", "fortran", "kdl", "c", "cpp"},
	    callback = function()
            vim.opt_local.commentstring = "// %s"
	    end,
    }
)

-- vim.api.nvim_create_augroup('verilog_maps', { clear = true })
-- vim.api.nvim_create_autocmd('FileType', {
--   group = 'verilog_maps',
--   pattern = 'verilog',
--   callback = function()
--     local opts = { buffer = true, silent = true }
--     vim.keymap.set('n', '[m', '?^\\s*module\\><CR>', opts)
--     vim.keymap.set('n', ']m', '/^\\s*module\\><CR>', opts)
--     vim.keymap.set('n', '[M', '?^\\s*endmodule\\><CR>', opts)
--     vim.keymap.set('n', ']M', '/^\\s*endmodule\\><CR>', opts)
--   end,
-- })

