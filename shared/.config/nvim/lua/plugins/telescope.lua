-- Telescope: fuzzy finder over files, grep, symbols, etc.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Grep word under cursor" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top", horizontal = { preview_width = 0.55 } },
          winblend = 0,
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          mappings = { i = { ["<C-u>"] = false, ["<Esc>"] = require("telescope.actions").close } },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
