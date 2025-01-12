local wk = require("which-key")

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
  },
  window = {
    border = "single",
    padding = { 2, 2, 2, 2 },
  },
  show_help = true,
})

-- Spacemacs-like bindings
wk.register({
  -- File operations (SPC f)
  f = {
    name = "File",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
    s = { "<cmd>write<cr>", "Save File" },
    t = { "<cmd>NvimTreeToggle<cr>", "Toggle Tree" },
    y = { "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", "Yank History" },
  },

  -- Buffer operations (SPC b)
  b = {
    name = "Buffer",
    b = { "<cmd>Telescope buffers<cr>", "Switch Buffer" },
    d = { "<cmd>bdelete<cr>", "Delete Buffer" },
    n = { "<cmd>bnext<cr>", "Next Buffer" },
    p = { "<cmd>bprevious<cr>", "Previous Buffer" },
    r = { "<cmd>e!<cr>", "Reload Buffer" },
  },

  -- Window operations (SPC w)
  w = {
    name = "Window",
    h = { "<C-w>h", "Left Window" },
    j = { "<C-w>j", "Down Window" },
    k = { "<C-w>k", "Up Window" },
    l = { "<C-w>l", "Right Window" },
    v = { "<cmd>vsplit<cr>", "Vertical Split" },
    s = { "<cmd>split<cr>", "Horizontal Split" },
    d = { "<cmd>close<cr>", "Delete Window" },
  },

  -- Search/Symbol operations (SPC s)
  s = {
    name = "Search",
    p = { "<cmd>Telescope live_grep<cr>", "Search Project" },
    b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search Buffer" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
  },

  -- Project operations (SPC p)
  p = {
    name = "Project",
    f = { "<cmd>Telescope git_files<cr>", "Find File" },
    p = { "<cmd>Telescope projects<cr>", "Switch Project" },
    t = { "<cmd>TodoTelescope<cr>", "Todo List" },
  },

  -- Git operations (SPC g)
  g = {
    name = "Git",
    s = { "<cmd>Telescope git_status<cr>", "Status" },
    b = { "<cmd>Telescope git_branches<cr>", "Branches" },
    c = { "<cmd>Telescope git_commits<cr>", "Commits" },
    d = { "<cmd>DiffviewOpen<cr>", "Diff View" },
    g = { "<cmd>LazyGit<cr>", "LazyGit" },
  },

  -- LSP operations (SPC l)
  l = {
    name = "LSP",
    d = { vim.lsp.buf.definition, "Go to Definition" },
    D = { vim.lsp.buf.declaration, "Go to Declaration" },
    r = { vim.lsp.buf.references, "References" },
    i = { vim.lsp.buf.implementation, "Implementation" },
    R = { vim.lsp.buf.rename, "Rename" },
    a = { vim.lsp.buf.code_action, "Code Action" },
    f = { vim.lsp.buf.format, "Format" },
    h = { vim.lsp.buf.hover, "Hover" },
  },

  -- Toggle operations (SPC t)
  t = {
    name = "Toggle",
    t = { "<cmd>ToggleTerm<cr>", "Terminal" },
    n = { "<cmd>set number!<cr>", "Line Numbers" },
    r = { "<cmd>set relativenumber!<cr>", "Relative Numbers" },
    w = { "<cmd>set wrap!<cr>", "Word Wrap" },
    s = { "<cmd>set spell!<cr>", "Spell Check" },
  },

  -- Help (SPC h)
  h = {
    name = "Help",
    t = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
    k = { "<cmd>Telescope keymaps<cr>", "Key Mappings" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
  },

  -- Quit operations (SPC q)
  q = {
    name = "Quit",
    q = { "<cmd>quit<cr>", "Quit" },
    w = { "<cmd>wq<cr>", "Save & Quit" },
    a = { "<cmd>qall<cr>", "Quit All" },
  },

  -- Code operations (SPC c)
  c = {
    name = "Code",
    a = { vim.lsp.buf.code_action, "Code Actions" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
    f = { vim.lsp.buf.format, "Format Document" },
    r = { vim.lsp.buf.rename, "Rename Symbol" },
    s = { "<cmd>AerialToggle<cr>", "Toggle Symbol Outline" },
    x = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
  },

  -- Debug operations (SPC d)
  d = {
    name = "Debug",
    b = { "<cmd>DapToggleBreakpoint<cr>", "Toggle Breakpoint" },
    c = { "<cmd>DapContinue<cr>", "Continue/Start Debug" },
    i = { "<cmd>DapStepInto<cr>", "Step Into" },
    o = { "<cmd>DapStepOver<cr>", "Step Over" },
    O = { "<cmd>DapStepOut<cr>", "Step Out" },
    t = { "<cmd>DapTerminate<cr>", "Terminate" },
    u = { "<cmd>DapUiToggle<cr>", "Toggle Debug UI" },
  },

  -- View operations (SPC v)
  v = {
    name = "View",
    e = { "<cmd>Neotree toggle<cr>", "Toggle Explorer" },
    s = { "<cmd>AerialToggle<cr>", "Toggle Symbol Outline" },
    p = { "<cmd>Telescope projects<cr>", "Show Projects" },
    t = { "<cmd>ToggleTerm direction=float<cr>", "Toggle Terminal" },
    z = { "<cmd>ZenMode<cr>", "Toggle Zen Mode" },
  },
}, { prefix = "<leader>" })
