-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("nocturne-yank", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Return to last edit position when opening a file
autocmd("BufReadPost", {
  group = augroup("nocturne-lastpos", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Trim trailing whitespace on save
autocmd("BufWritePre", {
  group = augroup("nocturne-trim", { clear = true }),
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Filetype-specific indentation
autocmd("FileType", {
  group = augroup("nocturne-indent", { clear = true }),
  pattern = { "lua", "yaml", "json", "jsonc", "html", "css", "scss", "javascript", "typescript", "nix", "toml" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

-- Close some utility buffers with `q`
autocmd("FileType", {
  group = augroup("nocturne-q-close", { clear = true }),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
