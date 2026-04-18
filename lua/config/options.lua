local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.showmode = false
opt.signcolumn = "yes:1"
opt.cursorline = true
opt.cmdheight = 1
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.numberwidth = 5
opt.fillchars = {
  horiz = "━", horizup = "┻", horizdown = "┳",
  vert = "┃", vertleft = "┫", vertright = "┣", verthoriz = "╋",
  eob = " ",
}

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.equalalways = false

-- Window
opt.winminheight = 1
opt.winminwidth = 5
opt.winheight = 5
opt.winwidth = 10
opt.winblend = 10
opt.pumblend = 10
opt.background = "dark"

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true
opt.wrap = false

-- Files
opt.fileencoding = "utf-8"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.hidden = true

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.synmaxcol = 200

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Clipboard & mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Wild menu
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

-- Folding (treesitter-based, disabled by default)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
opt.foldlevel = 99

-- Concealment
opt.conceallevel = 2

-- Copilot globals (must be set before the plugin loads)
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.copilot_idle_delay = 75

-- Load user custom options if present
local custom_options = vim.fn.stdpath("config") .. "/lua/custom/options.lua"
if vim.loop.fs_stat(custom_options) then
  dofile(custom_options)
end
