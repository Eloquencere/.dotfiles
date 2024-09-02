return {
    "rcarriga/nvim-notify",
    config = function()
        require("notify").setup({
        background_colour = "NotifyBackground",
        fps = 30,
        icons = {
            DEBUG = "",
            ERROR = "",
            INFO = "",
            TRACE = "✎",
            WARN = ""
        },
        level = 2,
        minimum_width = 50,
        max_width = 100,
        render = "default",
        stages = "fade",
        time_formats = {
            notification = "%T",
            notification_history = "%FT%T"
        },
        timeout = 4000,
        top_down = true
        })
        local notif = require("notify")
        vim.notify = notif
    end,
}
