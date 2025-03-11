return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			-- Add your oil configuration here
			view_options = {
				show_hidden = true,
			},
		})
	end,
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
