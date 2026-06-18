return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        enabled = true,
        keys = { "f", "F", "t", "T" },
        jump_labels = true,
      },
    },
  },
}

