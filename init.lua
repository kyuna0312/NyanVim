-- Set leader key before loading any plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")

-- Load lazy.nvim and plugins (synchronous so VimEnter-triggered plugins,
-- e.g. the dashboard, register before VimEnter fires)
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
require("nyanvim.discipline").cowboy()
