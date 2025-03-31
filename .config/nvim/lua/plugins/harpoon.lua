return {
    -- Harpoon plugin configuration
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = false,
        requires = { "nvim-lua/plenary.nvim" }, -- if harpoon requires this
        config = function()
            require("harpoon").setup({})

            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                }):find()
            end
            vim.keymap.set("n", "<leader>a", function()
                local harpoon = require("harpoon")
                toggle_telescope(harpoon:list())
            end, { desc = "Open harpoon window" })
        end,
        keys = {
            {
                "<leader>A",
                function()
                    require("harpoon"):list():append()
                end,
                desc = "harpoon file",
            },
            {
                "<C-b>",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "harpoon quick menu",
            },
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "harpoon to file 1",
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "harpoon to file 2",
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "harpoon to file 3",
            },
        },
    },
}

