-- Set leader key before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")
require("config.lazy") -- Load lazy.nvim and plugins
require("config.keymaps")
require("config.autocmds")
