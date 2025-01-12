return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        transparent = false,
        term_colors = true,
        ending_tildes = false,
        toggle_style_key = "<leader>ts",
        code_style = {
          comments = "italic",
          keywords = "bold",
          functions = "none",
          strings = "none",
          variables = "none",
        },
      })
      require("onedark").load()
    end,
  },
}
