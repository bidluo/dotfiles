-- Coding: formatting (conform) + integrated terminal (toggleterm).
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        rust = { "rustfmt" },
      },
      format_on_save = function(bufnr)
        -- Respect a per-buffer/global opt-out toggle (see keymap below).
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.keymap.set("n", "<leader>uf", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify((vim.g.disable_autoformat and "Disabled" or "Enabled") .. " format on save")
      end, { desc = "Toggle format on save" })
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Float terminal" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = { border = "rounded" },
      shade_terminals = false,
    },
  },
}
