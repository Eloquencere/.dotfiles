return {
    "folke/todo-comments.nvim",
    event = { "VeryLazy" },
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo_comments = require("todo-comments")

        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })

        keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })

        todo_comments.setup()
    end,

    -- Types of todo-comments
    -- NOTE    additional point to the reader
    -- TODO    To be completed
    -- DOUBT   intent not clear
    -- HACK    this looks funky
    -- BUG     There is a problem here or might cause problems later
    -- FIX     this needs urgent attention and fixing (along with possible resolution)
    -- OPTIM   Further optimise
    -- TEST    Needs to be checked
}
