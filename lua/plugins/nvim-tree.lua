return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus file explorer" },
  },
  init = function()
    vim.g.nvim_tree_side = 'right'
  end,
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)
    end,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 35,
      side = "right",
      preserve_window_proportions = true,
      number = false,
      relativenumber = false,
      signcolumn = "yes",
      float = {
        enable = false,
      },
    },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { "node_modules", "\\.cache" },
    },
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
        resize_window = true,
      },
    },
  },
  config = function(_, opts)
    local api = require("nvim-tree.api")
    local view = require("nvim-tree.view")

    require("nvim-tree").setup(opts)

    local group = vim.api.nvim_create_augroup("NvimTreeGroup", { clear = true })

    local function resize_tree()
      if view.is_visible() then
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 35")
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "NvimTree",
      callback = resize_tree,
    })

    vim.api.nvim_create_autocmd("VimResized", {
      group = group,
      callback = resize_tree,
    })

    local toggle_tree = api.tree.toggle
    api.tree.toggle = function(...)
      toggle_tree(...)
      resize_tree()
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          api.tree.open()
          resize_tree()
        end
      end,
    })
  end,
}
