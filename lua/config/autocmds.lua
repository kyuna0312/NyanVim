-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General settings
local general = augroup("General", { clear = true })

-- Highlight on yank
autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Resize splits if window got resized
autocmd({ "VimResized" }, {
  group = general,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Go to last location when opening a buffer
autocmd("BufReadPost", {
  group = general,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = general,
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create dir when saving a file
autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- LSP settings
local lsp = augroup("LSP", { clear = true })

-- Format on save
autocmd("BufWritePre", {
  group = lsp,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Show diagnostic on hover
autocmd("CursorHold", {
  group = lsp,
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Set transparent background
local function set_transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
end

-- Create an autocommand group for transparency
local transparent_group = vim.api.nvim_create_augroup("TransparentBackground", { clear = true })

-- Apply transparency when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent_bg,
  group = transparent_group,
})

-- Apply transparency when Neovim starts
set_transparent_bg()

-- Treesitter window management
local treesitter_group = vim.api.nvim_create_augroup("TreesitterWindow", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = treesitter_group,
  pattern = "nvim-treesitter-playground",
  callback = function(event)
    -- Move treesitter window to the far right
    vim.cmd("wincmd L")
    -- Set minimum width for treesitter window
    vim.cmd("vertical resize 40")
    -- Make it a fixed size
    vim.cmd("set winfixwidth")
  end,
})

-- Optimize window layout (Centaur-style)
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("WindowOptimize", { clear = true }),
  callback = function()
    -- Optimize window layout on startup
    vim.cmd("wincmd =")
  end,
})

-- Better window navigation
local function smart_split()
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)
  if width > 2 * height then
    return "vertical split"
  else
    return "split"
  end
end

vim.api.nvim_create_user_command("SmartSplit", function()
  vim.cmd(smart_split())
end, {})

-- VSCode-like sidebar management
local sidebar_group = vim.api.nvim_create_augroup("SidebarManagement", { clear = true })

-- Ensure NvimTree opens on the right
vim.api.nvim_create_autocmd("FileType", {
  group = sidebar_group,
  pattern = "NvimTree",
  callback = function()
    -- Move tree to the right
    vim.cmd("wincmd L")
    -- Set a reasonable width like VSCode
    vim.cmd("vertical resize 40")
    -- Make it a fixed size
    vim.cmd("set winfixwidth")
  end,
})

-- Auto resize windows when terminal is resized (VSCode-like behavior)
vim.api.nvim_create_autocmd("VimResized", {
  group = sidebar_group,
  callback = function()
    -- Balance windows on resize, but maintain sidebar width
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
      local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype")
      if ft == "NvimTree" then
        vim.api.nvim_win_set_width(win, 40)
      end
    end
  end,
})

-- PyCharm-like file explorer behavior
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreePyCharmBehavior", { clear = true }),
  callback = function()
    local api = require('nvim-tree.api')
    local view = require('nvim-tree.view')

    -- Auto-open NvimTree when opening a directory
    if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
      api.tree.open()
    end

    -- Update tree root when changing directories
    if view.is_visible() then
      api.tree.find_file({ open = true, focus = false })
    end
  end,
})

-- Highlight current file in tree
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("NvimTreeHighlight", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "NvimTree" then
      local api = require('nvim-tree.api')
      api.tree.find_file({ focus = false })
    end
  end,
})

-- Copilot autocmds (PyCharm-like behavior)
local copilot_group = vim.api.nvim_create_augroup("CopilotGroup", { clear = true })

-- Disable Copilot in certain contexts (like PyCharm)
vim.api.nvim_create_autocmd("FileType", {
  group = copilot_group,
  pattern = { "TelescopePrompt", "markdown", "help", "txt" },
  callback = function()
    -- Check if Copilot exists before trying to disable it
    local ok, _ = pcall(require, "copilot.client")
    if ok then
      vim.cmd("Copilot disable")
    end
  end,
})

-- Add a safety check for Copilot commands
local function safe_copilot_cmd(cmd)
  local ok, _ = pcall(vim.cmd, "Copilot " .. cmd)
  if not ok then
    -- Silently fail if Copilot isn't available
    return false
  end
  return true
end

-- Update the InsertEnter autocmd as well
vim.api.nvim_create_autocmd("InsertEnter", {
  group = copilot_group,
  callback = function()
    safe_copilot_cmd("enable")
  end,
})

-- Update the BufEnter autocmd for statusline
vim.api.nvim_create_autocmd("BufEnter", {
  group = copilot_group,
  callback = function()
    -- Check if Copilot API is available before using it
    local ok, copilot_api = pcall(require, "copilot.api")
    if ok then
      local status_ok, _ = pcall(function()
        vim.opt_local.statusline = vim.opt_local.statusline +
          string.format(' %%{%s}', 'v:lua.require("copilot.api").status.data.message')
      end)
      if not status_ok then
        -- Silently fail if statusline update fails
      end
    end
  end,
})

-- Update the existing NvimTree autocmd or add this if it doesn't exist
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NvimTreePosition", { clear = true }),
  pattern = "NvimTree",
  callback = function()
    -- Ensure tree is always on the right
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 35")
    -- Lock the window size
    vim.cmd("set winfixwidth")
  end,
})

-- Add this to handle window resizing
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("NvimTreeResize", { clear = true }),
  callback = function()
    local view = require("nvim-tree.view")
    if view.is_visible() then
      -- Maintain tree width after terminal resize
      vim.cmd("wincmd L")
      vim.cmd("vertical resize 35")
    end
  end,
})

-- Disable nvim-tree on dashboard
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dashboard",
  callback = function()
    -- Close nvim-tree if it's open
    local view = require("nvim-tree.view")
    if view.is_visible() then
      view.close()
    end
    -- Prevent nvim-tree from opening automatically
    vim.opt_local.modifiable = false
    vim.opt_local.bufhidden = "wipe"
  end,
})

-- Remove or comment out these lines since we're using the plugin config
-- Auto-open dashboard on startup
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
--       require("dashboard").setup()
--     end
--   end,
-- })
