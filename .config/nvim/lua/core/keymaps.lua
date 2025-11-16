-- Key Remaps
vim.g.mapleader = " " -- Leader key is Space
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- Search
keymap.set(
    { "n", "v" },
    "/",
    "/\\v",
    { noremap = true, desc = "Search pattern" }
)
keymap.set(
    "n",
    "S",
    ":%s/\\v//g" .. ("<left>"):rep(3),
    { noremap = true, desc = "Search and replace" }
)

-- Split Windows
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
keymap.set(
    "n",
    "<leader>se",
    "<C-w>=",
    { desc = "Make splits equal size" }
)

-- Moving between buffers
keymap.set(
    {"n", "i", "v"},
    '<C-Tab>',
    '<Cmd>bnext<CR>',
    { noremap = true, silent = true, desc = "Move to next buffer" }
)
keymap.set(
    {"n", "i", "v"},
    '<C-S-Tab>',
    '<Cmd>bNext<CR>',
    { noremap = true, silent = true, desc = "Move to previous buffer" }
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

