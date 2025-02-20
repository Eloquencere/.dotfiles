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
opt.splitright = true
opt.splitbelow = true
opt.backspace = "indent,eol,start"

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Split Windows
opt.splitright = true
opt.splitbelow = true

-- Setting comment strings
vim.api.nvim_create_autocmd(
    { "FileType" },
	{ 
	    pattern = { "verilog", "systemverilog", "fortran" },
	    callback = function()
            vim.opt_local.commentstring = "// %s"
	    end,
    }
)

-- Enabling syntax highlighting for verilog files
vim.api.nvim_create_autocmd(
    { "FileType" }, 
    {
        pattern = { "*.v" },
        command = "setlocal syntax=verilog",
    }
)

-- Disabling syntax highlighting for .f files
vim.api.nvim_create_autocmd(
    { "FileType" },
    {
        pattern = { "fortran" },
        command = "syntax off",
    }
)

