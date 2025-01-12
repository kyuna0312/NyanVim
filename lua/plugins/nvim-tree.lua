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
    -- Ensure first open is on the right side
    vim.g.nvim_tree_side = 'right'
  end,
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

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
      side = "right", -- Set default side to right
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
          enable = false, -- Disable window picker for more predictable behavior
        },
        resize_window = true,
      },
    },
  },
  config = function(_, opts)
    -- Configure NvimTree
    require("nvim-tree").setup(opts)

    -- Create autocmd group for NvimTree
    local group = vim.api.nvim_create_augroup("NvimTreeGroup", { clear = true })

    -- Ensure tree opens on the right side
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "NvimTree",
      callback = function()
        -- Force window to right side
        vim.cmd("wincmd L")
        -- Set width
        vim.cmd("vertical resize 35")
      end,
    })

    -- Keep tree on the right when window is resized
    vim.api.nvim_create_autocmd("VimResized", {
      group = group,
      callback = function()
        local view = require("nvim-tree.view")
        if view.is_visible() then
          vim.cmd("wincmd L")
          vim.cmd("vertical resize 35")
        end
      end,
    })

    -- Override the default toggle function
    local api = require("nvim-tree.api")
    local view = require("nvim-tree.view")

    local toggle_tree = api.tree.toggle
    api.tree.toggle = function(...)
      toggle_tree(...)
      if view.is_visible() then
        vim.cmd("wincmd L")
        vim.cmd("vertical resize 35")
      end
    end

    -- Open tree when vim starts with a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function(data)
        local directory = vim.fn.isdirectory(data.file) == 1
        if directory then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
          vim.cmd("wincmd L")
          vim.cmd("vertical resize 35")
        end
      end,
    })
  end,
}
