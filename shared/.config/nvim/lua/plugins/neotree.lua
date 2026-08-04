-- Neo-tree: persistent sidebar file explorer (the modern NERDTree).
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal left<CR>", desc = "File tree (toggle)" },
      { "<leader>E", "<cmd>Neotree focus<CR>", desc = "File tree (focus)" },
      { "<leader>ge", "<cmd>Neotree float git_status<CR>", desc = "Git tree (float)" },
      { "<leader>be", "<cmd>Neotree toggle buffers right<CR>", desc = "Buffer tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sources = { "filesystem", "buffers", "git_status" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },   -- reveal the file you're editing
        use_libuv_file_watcher = true,              -- live-refresh on disk changes
        filtered_items = {
          visible = false,          -- press H in the tree to reveal hidden/gitignored
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["<space>"] = "none",     -- keep <leader> usable while focused in the tree
          ["H"] = "toggle_hidden",
          ["<cr>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = true } },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
        git_status = {
          symbols = {
            added = "", modified = "", deleted = "", renamed = "",
            untracked = "", ignored = "", unstaged = "󰄱", staged = "", conflict = "",
          },
        },
      },
    },
  },
}
