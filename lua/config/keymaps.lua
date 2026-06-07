-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate down window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate up window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate right window" })

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- File operations
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qall<cr>", { desc = "Quit all" })

-- Buffer operations
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Clear search highlights
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear highlights" })

-- LSP
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Show hover" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "<leader>f", vim.lsp.buf.format, { desc = "Format code" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })

-- NvimTree
map("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  local view = require("nvim-tree.view")

  if not view.is_visible() then
    api.tree.open()
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 35")
  else
    api.tree.close()
  end
end, { desc = "Toggle Explorer (Force Right)" })

-- Terminal
map("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window management keymaps (Centaur-style)
vim.keymap.set("n", "<C-x>2", "<cmd>SmartSplit<CR>", { desc = "Split window intelligently" })
vim.keymap.set("n", "<C-x>3", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<C-x>0", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set("n", "<C-x>o", "<cmd>wincmd w<CR>", { desc = "Next window" })

-- Window resize
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Quick window navigation
vim.keymap.set("n", "<M-1>", "1<C-w>w", { desc = "Go to window 1" })
vim.keymap.set("n", "<M-2>", "2<C-w>w", { desc = "Go to window 2" })
vim.keymap.set("n", "<M-3>", "3<C-w>w", { desc = "Go to window 3" })
vim.keymap.set("n", "<M-4>", "4<C-w>w", { desc = "Go to window 4" })

-- Add these VSCode-like keymaps

-- Toggle sidebar with Ctrl+B like VSCode
vim.keymap.set("n", "<C-b>", function()
  local api = require("nvim-tree.api")
  api.tree.toggle()
end, { desc = "Toggle Explorer (Right Side)" })

-- Focus sidebar with Ctrl+Shift+E like VSCode
vim.keymap.set("n", "<C-S-e>", function()
  vim.cmd("NvimTreeFocus")
end, { desc = "Focus Explorer" })

-- File explorer actions (similar to VSCode)
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find Current File" })
vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh Explorer" })
vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse Explorer" })

-- Quick sidebar sizing (like VSCode)
vim.keymap.set("n", "<leader>e]", function()
  vim.cmd("vertical resize +10")
end, { desc = "Increase sidebar width" })
vim.keymap.set("n", "<leader>e[", function()
  vim.cmd("vertical resize -10")
end, { desc = "Decrease sidebar width" })

-- Add these PyCharm-like keymaps

-- Double-click behavior (expand/collapse or open file)
vim.keymap.set("n", "<2-LeftMouse>", function()
  local api = require('nvim-tree.api')
  api.node.open.edit()
end, { desc = "Open file or expand folder" })

-- Quick file creation in tree
vim.keymap.set("n", "<leader>ef", function()
  local api = require('nvim-tree.api')
  api.fs.create()
end, { desc = "Create new file" })

-- Quick folder creation in tree
vim.keymap.set("n", "<leader>ed", function()
  local api = require('nvim-tree.api')
  api.fs.create(true)
end, { desc = "Create new directory" })

-- Quick rename
vim.keymap.set("n", "<F2>", function()
  local api = require('nvim-tree.api')
  api.fs.rename()
end, { desc = "Rename file/folder" })

-- Quick delete
vim.keymap.set("n", "<Del>", function()
  local api = require('nvim-tree.api')
  api.fs.remove()
end, { desc = "Delete file/folder" })

-- Add these Copilot keymaps (PyCharm-like)
vim.keymap.set("i", "<M-\\>", function()
  local ok, _ = pcall(vim.cmd, "Copilot panel")
  if not ok then
    vim.notify("Copilot not available", vim.log.levels.WARN)
  end
end, { desc = "Toggle Copilot Panel" })

vim.keymap.set("i", "<M-]>", function()
  local ok, _ = pcall(vim.cmd, "Copilot accept")
  if not ok then
    vim.notify("Copilot not available", vim.log.levels.WARN)
  end
end, { desc = "Accept Copilot suggestion" })

vim.keymap.set("i", "<M-[>", function()
  -- Dismiss current suggestion
  vim.cmd("Copilot dismiss")
end, { desc = "Dismiss Copilot suggestion" })

vim.keymap.set("i", "<M-n>", function()
  -- Next suggestion
  vim.cmd("Copilot next")
end, { desc = "Next Copilot suggestion" })

vim.keymap.set("i", "<M-p>", function()
  -- Previous suggestion
  vim.cmd("Copilot prev")
end, { desc = "Previous Copilot suggestion" })

-- Quick toggle for Copilot
vim.keymap.set("n", "<leader>tc", function()
  vim.cmd("Copilot toggle")
end, { desc = "Toggle Copilot" })

-- Enhanced Telescope keymaps
vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files({
    hidden = true,
    no_ignore = false,
    file_ignore_patterns = { ".git/", "node_modules/" },
  })
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden" }
    end,
  })
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fb", function()
  require("telescope.builtin").buffers({
    sort_mru = true,
    ignore_current_buffer = true,
  })
end, { desc = "Find buffers" })

-- Quick buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })

-- Quick file browsing
vim.keymap.set("n", "<leader>.", "<cmd>Telescope file_browser<cr>", { desc = "Browse files" })
vim.keymap.set("n", "<leader>,", "<cmd>Telescope file_browser path=%:p:h<cr>", { desc = "Browse current dir" })

-- Recent files
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- Project search
vim.keymap.set("n", "<leader>sp", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Search current word" })

-- Add these Mason-related keymaps
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })
vim.keymap.set("n", "<leader>ci", "<cmd>MasonInstall<cr>", { desc = "Mason Install" })
vim.keymap.set("n", "<leader>cu", "<cmd>MasonUninstall<cr>", { desc = "Mason Uninstall" })
vim.keymap.set("n", "<leader>cl", "<cmd>MasonLog<cr>", { desc = "Mason Log" })

-- Add these search-related keymaps
-- Global search (like PyCharm's double Shift)
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Search files" })
vim.keymap.set("n", "<C-S-f>", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", { desc = "Search in project" })
vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search in file" })

-- Search word under cursor (like PyCharm's middle click)
vim.keymap.set("n", "<leader>*", function()
  local word = vim.fn.expand("<cword>")
  require("telescope.builtin").grep_string({
    word_match = "-w",
    search = word,
    initial_mode = "normal",
  })
end, { desc = "Search word under cursor" })

-- Recent files (like PyCharm's Ctrl+E)
vim.keymap.set("n", "<C-e>", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- Symbol search (like PyCharm's Ctrl+Alt+Shift+N)
vim.keymap.set("n", "<C-S-s>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Search symbols" })

-- File structure (like PyCharm's Ctrl+F12)
vim.keymap.set("n", "<C-F12>", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "File structure" })
