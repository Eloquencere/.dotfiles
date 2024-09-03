-- Key Remaps
vim.g.mapleader = " " -- Leader key is Space
vim.g.maplocalleader = " "

local keymap = vim.keymap

vim.cmd("nnoremap <silent> k :<C-U>execute \'normal!\' (v:count > 1 ? \"m\'\" . v:count : \'\') . \'k\'<CR>")
vim.cmd("nnoremap <silent> j :<C-U>execute \'normal!\' (v:count > 1 ? \"m\'\" . v:count : \'\') . \'j\'<CR>")

-- Moving between tabs
keymap.set(
    {"n", "i", "v"},
    "<C-S-Tab>",
    "<Cmd>BufferPrevious<CR>",
    { desc = "Go to the next tab"}
)

keymap.set(
    {"n", "i", "v"},
    "<C-Tab>",
    "<Cmd>BufferNext<CR>",
    { desc = "Go to the next tab"}
)

-- Move up and down editor lines
keymap.set(
    "n",
    "j",
    "gjzz",
    { noremap = true, silent = true, desc = "Aligns the screen when scrolling down" }
)
keymap.set(
    "n",
    "k",
    "gkzz",
    { noremap = true, silent = true, desc = "Aligns the screen when scrolling up" }
)

-- Split Navigation
keymap.set(
    "n",
    "<leader>h",
    ":split ",
    { noremap = true, desc = "Easier horizontal split of another file" }
)
keymap.set(
    "n",
    "<leader>v",
    ":vsplit ",
    { noremap = true, desc = "Easier vertical split of another file" }
)

-- Search
keymap.set(
    { "n", "v" },
    "/",
    "/\\v",
    { noremap = true, desc = "Search pattern" }
)
keymap.set(
    "n",
    "<ESC>",
    "<cmd>nohl<CR>",
    { silent = true, desc = "Clear search highlights" }
)
keymap.set(
    "n",
    "S",
    ":%s/\\v//g" .. ("<left>"):rep(3),
    { noremap = true, desc = "Easier horizontal split to another file" }
)

-- Split Windows
keymap.set(
    "n",
    "<leader>sv",
    "<C-w>v",
    { desc = "Split window vertically" }
)

keymap.set(
    "n",
    "<leader>sh",
    "<C-w>s",
    { desc = "Split window horizontally" }
)

keymap.set(
    "n",
    "<leader>se",
    "<C-w>=",
    { desc = "Make splits equal size" }
)

keymap.set(
    "n",
    "<leader>sx",
    "<cmd>close<CR>",
    { desc = "Close current split" }
)

-- Tabs
keymap.set(
    "n", "<leader>to",
    "<cmd>tabnew<CR>", { desc = "Open new tab" }
)

keymap.set(
    "n",
    "<leader>tx",
    "<cmd>tabclose<CR>",
    { desc = "Close current tab" }
)

keymap.set(
    "n",
    "<leader>tn",
    "<cmd>tabn<CR>",
    { desc = "Go to next tab" }
)

keymap.set(
    "n",
    "<leader>tp",
    "<cmd>tabp<CR>",
    { desc = "Go to previous tab" }
)

keymap.set(
    "n",
    "<leader>tf",
    "<cmd>tabnew %<CR>",
    { desc = "Open current buffer in new tab" }
)

-- Pair Completion
keymap.set(
    "i",
    "\"",
    "\"\"" .. "<left>",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "\'",
    "\'\'" .. "<left>",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "[",
    "[]" .. "<left>",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "(",
    "()" .. "<left>",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "(<CR>",
    "(<CR>)" .. "<ESC>O",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "(;<CR>",
    "(<CR>);" .. "<ESC>O",
    { noremap = true, desc = "Useful for port definitions in Verilog and SystemVerilog" }
)
keymap.set(
    "i",
    "{",
    "{}" .. "<left>",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "{<CR>",
    "{<CR>}" .. "<ESC>O",
    { noremap = true, desc = "insert" }
)
keymap.set(
    "i",
    "{;<CR>",
    "{<CR>};" .. "<ESC>O",
    { noremap = true, desc = "insert" }
)

-- Spell Checker
keymap.set(
    "n",
    "<leader>s",
    "<cmd>setlocal spell spelllang=en_us" .. "<CR>",
    { silent = true, desc = "insert" }
)
keymap.set(
    "n",
    "<leader>S",
    "<cmd>setlocal nospell" .. "<CR>",
    { silent = true, desc = "insert" }
)

-- Increment / Decrement Numbers
keymap.set(
    "n",
    "<leader>+",
    "<C-a>",
    { noremap = true, silent = true, desc = "Increment number" }
)
keymap.set(
    "n",
    "<leader>-",
    "<C-x>",
    { noremap = true, silent = true, desc = "Decrement number" }
)