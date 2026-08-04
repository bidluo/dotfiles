-- Editor options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showmode = false          -- lualine shows the mode
opt.clipboard = "unnamedplus" -- share the Wayland clipboard
opt.breakindent = true
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 400
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 8
opt.termguicolors = true
opt.confirm = true

-- Indentation (overridden per-filetype by autocmds / editorconfig)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Nicer fold defaults (treesitter-driven, expanded on open)
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Transparent-friendly: let the terminal (kitty) blur show through
opt.pumblend = 10
opt.winblend = 0

-- Disable some builtin providers we don't use (faster startup)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
