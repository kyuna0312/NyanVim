-- Set leader key before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")

-- Lazy-load plugins and configurations
vim.defer_fn(function()
  require("config.lazy") -- Load lazy.nvim and plugins
  require("config.keymaps")
  require("config.autocmds")
end, 0)
