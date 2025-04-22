return {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        keywords = {
            NOTE = {
                icon = " ",
                color = "hint",
                desc = { "Additional point to the reader" },
            },
            TODO = { 
                icon = " ",
                color = "info",
                desc = { "To be completed" },
            },
            DOUBT = {
                icon = " ",
                color = "warning",
                desc = "Intent not clear",
            },
            HACK = {
                icon = " ", 
                color = "warning",
                desc = "This looks funky",
            },
            FIX = {
                icon = " ",
                color = "error",
                alt = { "BUG", "ISSUE" },
                desc = "There is a problem here or might cause problems later",
            },
            WARN = {
                icon = " ",
                color = "warning",
                alt = { "WARNING"},
            },
            PERF = {
                icon = " ", 
                alt = { "OPTIM", "OPTIMIZE", "PERFORMANCE"},
            },
            TEST = {
                icon = "⏲ ",
                color = "test",
                desc = "Needs to be checked",
            },
        },
    },
    keys = {
        { mode = { "n" }, "]t", function() todo_comments.jump_next() end, desc = "Next todo comment" },
        { mode = { "n" }, "[t", function() todo_comments.jump_prev() end, desc = "Next todo comment" },
    }
}
