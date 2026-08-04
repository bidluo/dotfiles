-- Treesitter: syntax, indentation, textobjects.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
    main = "nvim-treesitter.configs",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    opts = {
      ensure_installed = {
        "bash", "c", "cpp", "css", "diff", "fish", "gitcommit", "gitignore",
        "html", "javascript", "json", "jsonc", "lua", "luadoc", "markdown",
        "markdown_inline", "python", "query", "regex", "rust", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ac"] = "@class.outer", ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
          },
        },
      },
    },
  },
}
