return {
  -- Active theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = false,
        terminal_colors = true,
      })
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
  -- craftzdog's theme: selectable via :colorscheme solarized-osaka
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
  },
}
