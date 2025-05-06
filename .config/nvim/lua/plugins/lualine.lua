return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
        -- Vim settings
        vim.opt.showmode = false
    end,
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")
        local colors = {
            blue = "#65D1FF",
            green = "#3EFFDC",
            violet = "#FF61EF",
            yellow = "#FFDA7B",
            red = "#FF4A4A",
            fg = "#D3D3D3",
            bg = "#1A1A1A",
            inactive_bg = "#2C3043",
        }
        local my_lualine_theme = {
            normal = {
                a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            insert = {
                a = { bg = colors.green, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            visual = {
                a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            command = {
                a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            replace = {
                a = { bg = colors.red, fg = colors.bg, gui = "bold" },
                b = { bg = colors.bg, fg = colors.fg },
                c = { bg = colors.bg, fg = colors.fg },
            },
            inactive = {
                a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
                b = { bg = colors.inactive_bg, fg = colors.semilightgray },
                c = { bg = colors.inactive_bg, fg = colors.semilightgray },
            },
        }

        -- Manually set mode strings with consistent length
        local mode_map = {
            n      = "NORMAL ",
            i      = "INSERT ",
            v      = "VISUAL ",
            V      = "V-LINE ",
            [""] = "V-BLOCK",
            c      = "COMMAND",
            R      = "REPLACE",
        }

        -- Add the Vim icon and mode to the left section
        lualine.setup({
            options = {
                theme = my_lualine_theme,
            },
            sections = {
                lualine_a = {
                    { 
                        'mode', 
                        fmt = function(mode)
                            local mode = vim.fn.mode()
                            local padded_mode = mode_map[mode] or mode
                            return "\u{e6ae} " .. padded_mode
                        end 
                    },
                },
                lualine_b = {
                    {
                        'buffers',
                        separator = { left = '', right = '' },
                        symbols = {
                            alternate_file = '',
                            directory =  '',
                        },
                        buffers_color = {
                            active = { fg = '#E0E0E0', bg = '#2E3440' },
                            inactive = { fg = '#BBBBBB', bg = "#1C1C1C" },
                        },
                    },
                },

                lualine_c = { '' },

                lualine_x = { '' },
                lualine_y = { 
                    {
                        'diff',
                        symbols = {added = ' ', modified = ' ', removed = ' '},
                        diff_color = {
                            added = {fg = colors.green},
                            modified = {fg = colors.yellow},
                            removed = {fg = colors.red},
                        },
                        separator = { left = '', right = ''},
                    },
                    'branch',
                    'fileformat',
                    -- 'filetype',
                    'progress', 
                },
                lualine_z = { 
                    'location'
                },
            },
            extensions = { 'lazy', 'mason', 'oil' },
        })
    end,
}

