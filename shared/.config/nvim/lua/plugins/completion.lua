-- Completion: blink.cmp (fast, modern) + LuaSnip + friendly-snippets.
return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*", -- use a release build (prebuilt fuzzy matcher)
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "v2.*", dependencies = { "rafamadriz/friendly-snippets" } },
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      snippets = { preset = "luasnip" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
