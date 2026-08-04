-- UI: statusline, dashboard, notifier, indent guides, better vim.ui.
return {
  -- Statusline (auto theme picks up the base16/matugen colors)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "snacks_dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
        },
      }
    end,
  },

  -- snacks: dashboard, notifier, indent guides, big-file handling, quality of life
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      notifier = { enabled = true, style = "compact" },
      words = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
   ███╗   ██╗ ██████╗  ██████╗████████╗██╗   ██╗██████╗ ███╗   ██╗███████╗
   ████╗  ██║██╔═══██╗██╔════╝╚══██╔══╝██║   ██║██╔══██╗████╗  ██║██╔════╝
   ██╔██╗ ██║██║   ██║██║        ██║   ██║   ██║██████╔╝██╔██╗ ██║█████╗
   ██║╚██╗██║██║   ██║██║        ██║   ██║   ██║██╔══██╗██║╚██╗██║██╔══╝
   ██║ ╚████║╚██████╔╝╚██████╗   ██║   ╚██████╔╝██║  ██║██║ ╚████║███████╗
   ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ]],
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git browse (open in remote)" },
    },
  },
}
