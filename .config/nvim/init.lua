-- Basic Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard:append("unnamedplus")
-- Alternative of swapfile as undo file and git integration

-- Whitespace
vim.opt.tabstop = 8            -- Number of spaces a tab character takes up
vim.opt.softtabstop = 8        
vim.opt.shiftwidth = 8	       -- Amount of spaces ">>" & "<<" take up
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.formatoptions = tcqrn1

-- Cursor motion
vim.opt.matchpairs:append('<:>')

-- Intricate settings
-- vim.opt.termguicolors = true
vim.opt.modelines = 0
vim.opt.visualbell = true
vim.opt.autochdir = true
vim.opt.splitright = true
vim.opt.splitbelow = true
-- configure the colour of the status line

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Key Remaps
vim.g.mapleader = ' '

-- Move up and down editor lines
vim.keymap.set(
	"n",
	"j",
	"gj",
	{noremap = true, silent = true, desc = "Aligns the screen when scrolling down"}
)
vim.keymap.set(
	"n",
	"k",
	"gk",
	{noremap = true, silent = true, desc = "Aligns the screen when scrolling up"}
)
vim.cmd("nnoremap <silent> k :<C-U>execute \'normal!\' (v:count > 1 ? \"m\'\" . v:count : \'\') . \'k\'<CR>")
vim.cmd("nnoremap <silent> j :<C-U>execute \'normal!\' (v:count > 1 ? \"m\'\" . v:count : \'\') . \'j\'<CR>")

-- Split Navigation
vim.keymap.set(
	"n",
	"<leader>h",
	":split ",
	{noremap = true, desc = "Easier horizontal split of another file"}
)
vim.keymap.set(
	"n",
	"<leader>v",
	":vsplit ",
	{noremap = true, desc = "Easier vertical split of another file"}
)

-- Search
vim.keymap.set(
	{"n","v"},
	"/",
	"/\\v",
	{noremap = true, desc = "Add here"}
)
vim.keymap.set(
	"n",
	"<ESC>",
	"<cmd>nohlsearch<CR>",
	{silent = true, desc = "Add here"}
)
vim.keymap.set(
	"n",
	"S",
	":%s/\\v//g" .. ("<left>"):rep(3),
	{noremap = true, desc = "Easier horizontal split to another file"}
)

-- Pair Completion
vim.keymap.set(
	"i",
	"\"",
	"\"\"" .. "<left>",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"\'",
	"\'\'" .. "<left>",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"[",
	"[]" .. "<left>",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"(",
	"()" .. "<left>",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"(<CR>",
	"(<CR>)" .. "<ESC>O",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"(;<CR>",
	"(<CR>);" .. "<ESC>O",
	{noremap = true, desc = "Useful for port definitions in Verilog and SystemVerilog"}
)
vim.keymap.set(
	"i",
	"{",
	"{}" .. "<left>",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"{<CR>",
	"{<CR>}" .. "<ESC>O",
	{noremap = true, desc = "insert"}
)
vim.keymap.set(
	"i",
	"{;<CR>",
	"{<CR>};" .. "<ESC>O",
	{noremap = true, desc = "insert"}
)

-- Spell Checker
vim.keymap.set(
	"n",
	"<leader>s",
	"<cmd>setlocal spell spelllang=en_us" .. "<CR>",
	{silent = true, desc = "insert"}
)
vim.keymap.set(
	"n",
	"<leader>S",
	"<cmd>setlocal nospell" .. "<CR>",
	{silent = true, desc = "insert"}
)
