-- Appearance
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.wrap           = false
vim.opt.lazyredraw     = true
-- vim.opt.scrolloff      = 10    -- Keep 10 lines above/below cursor
-- vim.opt.sidescrolloff  = 8     -- Keep 8 columns left/right cursor

-- Intricate settings
vim.opt.clipboard:append("unnamedplus")
vim.opt.backspace  = "indent,eol,start"
vim.opt.modelines  = 0
vim.opt.visualbell = true
vim.opt.autochdir  = true

-- Tabs and Indentation
vim.opt.tabstop       = 4    -- Number of spaces a tab character takes up
vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4    -- Amount of spaces ">>" & "<<" take up
vim.opt.expandtab     = true
vim.opt.autoindent    = true
vim.opt.smartindent   = true
vim.opt.breakindent   = true
vim.opt.formatoptions = tcqrn1

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- Split Windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- -- Enabling syntax highlighting for verilog files
-- vim.api.nvim_create_autocmd(
--     { "BufRead", "BufNewFile" }, 
--     {
--         pattern = { "*.v" },
--         callback = function()
--             vim.cmd("setfiletype verilog")
--         end,
--     }
-- )

-- Setting comment strings & disabling syntax highlighting
vim.api.nvim_create_autocmd(
    { "FileType" },
	{ 
	    pattern = { "fortran" },
	    callback = function()
            vim.opt_local.commentstring = "// %s"
            vim.cmd("syntax off")
	    end,
    }
)

-- Disabling the annoying snapping behaviour
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "systemverilog", "verilog" },
  callback = function()
    vim.bo.indentkeys = "!^F,o,O,0),0}"
  end,
})

