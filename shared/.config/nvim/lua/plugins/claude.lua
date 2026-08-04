-- claudecode.nvim — Claude Code as a sidebar inside Neovim.
-- Runs the `claude` CLI in a terminal split, connected to nvim over the same
-- IDE protocol the VS Code / JetBrains extensions use: selections and open
-- files become context automatically, and Claude's edits arrive as native
-- nvim diffs. Uses your existing Claude Code auth — no API key needed.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },  -- terminal provider (already installed)
    cmd = {
      "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSend", "ClaudeCodeAdd",
      "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeStatus",
    },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.32,
        provider = "snacks",
      },
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI / Claude" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude sidebar" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude session" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to context" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      -- accept / reject Claude's proposed edits
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
      -- from a neo-tree/oil buffer, add the file under the cursor to context
      { "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add tree file to context" },
    },
  },
}
