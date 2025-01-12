-- General Neovim settings
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.showmode = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.cmdheight = 1
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.conceallevel = 2

-- Window settings (corrected values)
opt.winminheight = 1
opt.winminwidth = 5
opt.winheight = 5
opt.winwidth = 10
opt.equalalways = false

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
opt.lazyredraw = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Clipboard
opt.clipboard = "unnamedplus"

-- Mouse
opt.mouse = "a"

-- Wild menu
opt.wildmode = "longest:full,full"
opt.wildoptions = "pum"

-- Enable transparency
vim.opt.termguicolors = true
vim.opt.winblend = 15      -- Make floating windows slightly transparent
vim.opt.pumblend = 15      -- Make popup menu slightly transparent

-- For neovim background transparency
vim.opt.background = "dark"
vim.api.nvim_set_option("termguicolors", true)

-- Window layout preferences
opt.splitright = true        -- Open vertical splits to the right
opt.splitbelow = true        -- Open horizontal splits below
opt.equalalways = false      -- Don't auto-balance window sizes

-- Enhanced UI elements
opt.termguicolors = true
opt.winblend = 15           -- Floating window transparency
opt.pumblend = 15           -- Popup menu transparency
opt.background = "dark"

-- Performance optimizations (like Centaur)
opt.redrawtime = 1500
opt.lazyredraw = true       -- Don't redraw while executing macros
opt.synmaxcol = 200         -- Only highlight the first 200 columns
opt.updatetime = 250        -- Faster completion
opt.timeoutlen = 300        -- Faster key sequence completion

-- Treesitter folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false      -- Don't fold by default
opt.foldlevel = 99

-- VSCode-like sidebar behavior
opt.splitright = true        -- Open splits on the right (for NvimTree)
opt.splitkeep = "screen"     -- Maintain window sizes when splitting
opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
  eob = ' ',                 -- Remove ~ for empty lines (like VSCode)
}

-- VSCode-like UI improvements
opt.pumblend = 10           -- Slight transparency for popups
opt.winblend = 10           -- Slight transparency for floating windows
opt.signcolumn = "yes:1"    -- Always show signcolumn with fixed width
opt.numberwidth = 5         -- Width of line number column
opt.scrolloff = 8          -- Keep cursor centered like VSCode
opt.sidescrolloff = 8      -- Horizontal scrolloff

-- Copilot UI improvements (PyCharm-like)
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Floating window appearance
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#83a598" })
vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#83a598" })
vim.api.nvim_set_hl(0, "CopilotSelection", { fg = "#83a598", bold = true })

-- More responsive suggestions
vim.g.copilot_idle_delay = 75  -- Faster suggestions (like PyCharm)
