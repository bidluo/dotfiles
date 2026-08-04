-- Editor niceties: file explorer, git signs, which-key, motions, pairs, surround.
return {
  -- Oil: edit the filesystem like a buffer
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
      float = { padding = 3, border = "rounded" },
      keymaps = { ["q"] = "actions.close" },
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory (Oil)" },
      { "<leader>fe", "<cmd>Oil<CR>", desc = "File explorer (Oil)" },
    },
  },

  -- Git signs in the gutter + hunk actions
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" }, change = { text = "▎" },
        delete = { text = "" }, topdelete = { text = "" }, changedelete = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = buf, desc = d }) end
        map("]h", gs.next_hunk, "Next hunk")
        map("[h", gs.prev_hunk, "Prev hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gs", gs.stage_hunk, "Stage hunk")
        map("<leader>gr", gs.reset_hunk, "Reset hunk")
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  -- Lazygit inside nvim
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
  },

  -- which-key: discoverable keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      win = { border = "rounded" },
      spec = {
        { "<leader>f", group = "find/file" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code" },
        { "<leader>b", group = "buffer" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>a", group = "ai/claude" },
      },
    },
  },

  -- Flash: fast cursor motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- todo-comments highlighting + search
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = { { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Todo comments" } },
  },

  -- mini.nvim: pairs, surround, comment-aware
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
  { "echasnovski/mini.surround", event = "VeryLazy", opts = {} },
  { "echasnovski/mini.ai", event = "VeryLazy", opts = {} },
}
