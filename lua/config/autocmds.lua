local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("General", { clear = true })

autocmd("TextYankPost", {
  group = general,
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

autocmd("VimResized", {
  group = general,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

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

autocmd("FileType", {
  group = general,
  pattern = {
    "qf", "help", "man", "notify", "lspinfo", "spectre_panel",
    "startuptime", "tsplayground", "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd("BufWritePre", {
  group = general,
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

local lsp = augroup("LSP", { clear = true })

autocmd("BufWritePre", {
  group = lsp,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

autocmd("CursorHold", {
  group = lsp,
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

local function set_transparent_bg()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
end

local transparent_group = augroup("TransparentBackground", { clear = true })

autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent_bg,
  group = transparent_group,
})

set_transparent_bg()

local treesitter_group = augroup("TreesitterWindow", { clear = true })

autocmd("FileType", {
  group = treesitter_group,
  pattern = "nvim-treesitter-playground",
  callback = function(event)
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 40")
    vim.cmd("set winfixwidth")
  end,
})

autocmd("VimEnter", {
  group = augroup("WindowOptimize", { clear = true }),
  callback = function()
    vim.cmd("wincmd =")
  end,
})

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

local sidebar_group = augroup("SidebarManagement", { clear = true })

autocmd("FileType", {
  group = sidebar_group,
  pattern = "NvimTree",
  callback = function()
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 40")
    vim.cmd("set winfixwidth")
  end,
})

autocmd("VimResized", {
  group = sidebar_group,
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
      local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype")
      if ft == "NvimTree" then
        vim.api.nvim_win_set_width(win, 40)
      end
    end
  end,
})

autocmd("BufEnter", {
  group = augroup("NvimTreePyCharmBehavior", { clear = true }),
  callback = function()
    local api = require('nvim-tree.api')
    local view = require('nvim-tree.view')
    if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
      api.tree.open()
    end
    if view.is_visible() then
      api.tree.find_file({ open = true, focus = false })
    end
  end,
})

autocmd("BufEnter", {
  group = augroup("NvimTreeHighlight", { clear = true }),
  callback = function()
    if vim.bo.filetype ~= "NvimTree" then
      local api = require('nvim-tree.api')
      api.tree.find_file({ focus = false })
    end
  end,
})

local copilot_group = augroup("CopilotGroup", { clear = true })

autocmd("FileType", {
  group = copilot_group,
  pattern = { "TelescopePrompt", "markdown", "help", "txt" },
  callback = function()
    local ok, _ = pcall(require, "copilot.client")
    if ok then
      vim.cmd("Copilot disable")
    end
  end,
})

local function safe_copilot_cmd(cmd)
  local ok, _ = pcall(vim.cmd, "Copilot " .. cmd)
  if not ok then return false end
  return true
end

autocmd("InsertEnter", {
  group = copilot_group,
  callback = function()
    safe_copilot_cmd("enable")
  end,
})

autocmd("BufEnter", {
  group = copilot_group,
  callback = function()
    local ok, copilot_api = pcall(require, "copilot.api")
    if ok then
      local status_ok, _ = pcall(function()
        vim.opt_local.statusline = vim.opt_local.statusline +
          string.format(' %%{%s}', 'v:lua.require("copilot.api").status.data.message')
      end)
      if not status_ok then end
    end
  end,
})

autocmd("FileType", {
  group = augroup("NvimTreePosition", { clear = true }),
  pattern = "NvimTree",
  callback = function()
    vim.cmd("wincmd L")
    vim.cmd("vertical resize 35")
    vim.cmd("set winfixwidth")
  end,
})

autocmd("VimResized", {
  group = augroup("NvimTreeResize", { clear = true }),
  callback = function()
    local view = require("nvim-tree.view")
    if view.is_visible() then
      vim.cmd("wincmd L")
      vim.cmd("vertical resize 35")
    end
  end,
})

autocmd("FileType", {
  pattern = "dashboard",
  callback = function()
    local view = require("nvim-tree.view")
    if view.is_visible() then
      view.close()
    end
    vim.opt_local.modifiable = false
    vim.opt_local.bufhidden = "wipe"
  end,
})
