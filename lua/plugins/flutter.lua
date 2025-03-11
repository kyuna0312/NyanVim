return {
	"nvim-flutter/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
		"nvim-telescope/telescope.nvim", -- for terminal integration
		"stevearc/oil.nvim", -- for oil integration
		"lukas-reineke/indent-blankline.nvim", -- for indent integration
		"nvim-snacks/snacks.lua", -- for snacks integration
	},
	config = function()
		require("flutter-tools").setup({})
		require("telescope").setup({})
		require("oil").setup({})
		require("indent_blankline").setup({})
		require("snacks").setup({})
	end,
}
