return {
	"stevearc/oil.nvim",
	config = function()
	  require("oil").setup({
		view_options = {
		  show_hidden = true,
		},
	  })
	end,
	dependencies = {
	  { "echasnovski/mini.icons", opts = {} },
	  -- Uncomment the following line if you prefer nvim-web-devicons
	  -- "nvim-tree/nvim-web-devicons",
	},
  }
