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
  win = {
    border = "single",
    padding = { 2, 2 },
  },
  show_help = true,
})

wk.add({
  -- File
  { "<leader>f", group = "File" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<leader>fs", "<cmd>write<cr>", desc = "Save File" },
  { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Tree" },
  { "<leader>fy", "<cmd>lua require('telescope').extensions.neoclip.default()<cr>", desc = "Yank History" },

  -- Buffer
  { "<leader>b", group = "Buffer" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer" },
  { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
  { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
  { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
  { "<leader>br", "<cmd>e!<cr>", desc = "Reload Buffer" },

  -- Window
  { "<leader>w", group = "Window" },
  { "<leader>wh", "<C-w>h", desc = "Left Window" },
  { "<leader>wj", "<C-w>j", desc = "Down Window" },
  { "<leader>wk", "<C-w>k", desc = "Up Window" },
  { "<leader>wl", "<C-w>l", desc = "Right Window" },
  { "<leader>wv", "<cmd>vsplit<cr>", desc = "Vertical Split" },
  { "<leader>ws", "<cmd>split<cr>", desc = "Horizontal Split" },
  { "<leader>wd", "<cmd>close<cr>", desc = "Delete Window" },

  -- Search
  { "<leader>s", group = "Search" },
  { "<leader>sp", "<cmd>Telescope live_grep<cr>", desc = "Search Project" },
  { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search Buffer" },
  { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

  -- Project
  { "<leader>p", group = "Project" },
  { "<leader>pf", "<cmd>Telescope git_files<cr>", desc = "Find File" },
  { "<leader>pp", "<cmd>Telescope projects<cr>", desc = "Switch Project" },
  { "<leader>pt", "<cmd>TodoTelescope<cr>", desc = "Todo List" },

  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
  { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
  { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },

  -- LSP
  { "<leader>l", group = "LSP" },
  { "<leader>ld", vim.lsp.buf.definition, desc = "Go to Definition" },
  { "<leader>lD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
  { "<leader>lr", vim.lsp.buf.references, desc = "References" },
  { "<leader>li", vim.lsp.buf.implementation, desc = "Implementation" },
  { "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
  { "<leader>lf", vim.lsp.buf.format, desc = "Format" },
  { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },

  -- Toggle
  { "<leader>t", group = "Toggle" },
  { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Terminal" },
  { "<leader>tn", "<cmd>set number!<cr>", desc = "Line Numbers" },
  { "<leader>tr", "<cmd>set relativenumber!<cr>", desc = "Relative Numbers" },
  { "<leader>tw", "<cmd>set wrap!<cr>", desc = "Word Wrap" },
  { "<leader>ts", "<cmd>set spell!<cr>", desc = "Spell Check" },

  -- Help
  { "<leader>h", group = "Help" },
  { "<leader>ht", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
  { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Mappings" },
  { "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },

  -- Quit
  { "<leader>q", group = "Quit" },
  { "<leader>qq", "<cmd>quit<cr>", desc = "Quit" },
  { "<leader>qw", "<cmd>wq<cr>", desc = "Save & Quit" },
  { "<leader>qa", "<cmd>qall<cr>", desc = "Quit All" },

  -- Code
  { "<leader>c", group = "Code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Actions" },
  { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
  { "<leader>cw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
  { "<leader>cf", vim.lsp.buf.format, desc = "Format Document" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename Symbol" },
  { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Toggle Symbol Outline" },
  { "<leader>cx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },

  -- AI / Claude
  { "<leader>a", group = "AI/Claude" },

  -- Debug
  { "<leader>d", group = "Debug" },
  { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
  { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue/Start Debug" },
  { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
  { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
  { "<leader>dO", "<cmd>DapStepOut<cr>", desc = "Step Out" },
  { "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
  { "<leader>du", "<cmd>DapUiToggle<cr>", desc = "Toggle Debug UI" },

  -- View
  { "<leader>v", group = "View" },
  { "<leader>ve", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
  { "<leader>vs", "<cmd>AerialToggle<cr>", desc = "Toggle Symbol Outline" },
  { "<leader>vp", "<cmd>Telescope projects<cr>", desc = "Show Projects" },
  { "<leader>vt", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Terminal" },
  { "<leader>vz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
})
