-- LSP: mason + lspconfig, tuned for David's stack (Lua, Rust, Python, TS, Bash).
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              diagnostics = { globals = { "vim", "hl" } }, -- 'hl' = the Hyprland Lua API
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
            },
          },
        },
        pyright = {},
        ts_ls = {},
        bashls = {},
      }

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", "shfmt", "prettier", "black", "isort",
        },
      })
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- LspAttach: buffer-local keymaps once a server connects.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nocturne-lsp-attach", { clear = true }),
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", require("telescope.builtin").lsp_definitions, "Goto definition")
          map("gr", require("telescope.builtin").lsp_references, "Goto references")
          map("gI", require("telescope.builtin").lsp_implementations, "Goto implementation")
          map("gy", require("telescope.builtin").lsp_type_definitions, "Type definition")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "Document symbols")

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })

      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })

      -- Set up each server (nvim-lspconfig ≥ current: use vim.lsp.config/enable).
      for name, opts in pairs(servers) do
        opts.capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {})
        vim.lsp.config(name, opts)
        vim.lsp.enable(name)
      end
    end,
  },
}
