return {
	"nvim-snacks/snacks.lua",
	config = function()
		require("snacks").setup({
			-- Add your snacks configuration here
			assets = {
				"lain.gif",
				"logo.cat"
			}
		})
	end,
}
