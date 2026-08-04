-- Colorscheme: Nocturne, a base16 theme driven by matugen (mini.base16).
-- Transparent background so kitty's blur shows through.
return {
  {
    "echasnovski/mini.base16",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      local palette = require("nocturne.palette")
      require("mini.base16").setup({
        palette = palette,
        use_cterm = true,
      })

      -- Transparency + a few tasteful overrides on top of the base16 highlights.
      local set = function(group, spec) vim.api.nvim_set_hl(0, group, spec) end
      local transparent = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn",
        "LineNr", "FoldColumn", "EndOfBuffer", "MsgArea", "TelescopeNormal",
        "TelescopeBorder", "WinSeparator",
      }
      for _, g in ipairs(transparent) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = g })
        if ok then
          hl.bg = nil
          hl.ctermbg = nil
          set(g, hl)
        end
      end

      set("CursorLine", { bg = palette.base01 })
      set("CursorLineNr", { fg = palette.base0D, bold = true })
      set("Comment", { fg = palette.base03, italic = true })
      set("WinSeparator", { fg = palette.base02, bg = "NONE" })
      set("Visual", { bg = palette.base02 })

      -- Expose a reload hook so the matugen `wall` script can recolor a running
      -- nvim:  nvim --server <pipe> --remote-send '<cmd>lua Nocturne_reload()<CR>'
      _G.Nocturne_reload = function()
        package.loaded["nocturne.generated"] = nil
        package.loaded["nocturne.palette"] = nil
        require("lazy.core.loader").reload("mini.base16")
        vim.cmd("doautocmd ColorScheme")
      end
    end,
  },

  -- Keep tokyonight available as a manual fallback (`:colorscheme tokyonight-night`).
  { "folke/tokyonight.nvim", lazy = true, opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } } },
}
