return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.completion.autocomplete = false
      opts.mapping["<CR>"] = nil
      local border_chars = {
        { "󱐋", "WarningMsg" },
        { "─", "Comment" },
        { "╮", "Comment" },
        { "│", "Comment" },
        { "╯", "Comment" },
        { "─", "Comment" },
        { "╰", "Comment" },
        { "│", "Comment" },
      }
      local documentation_border_chars = {
        { "󰙎", "DiagnosticHint" },
        { "─", "Comment" },
        { "╮", "Comment" },
        { "│", "Comment" },
        { "╯", "Comment" },
        { "─", "Comment" },
        { "╰", "Comment" },
        { "│", "Comment" },
      }
      opts.window = {
        completion = {
          border = border_chars,
          scrollbar = false,
          winblend = 0,
        },
        documentation = {
          border = documentation_border_chars,
          scrollbar = false,
          winblend = 0,
        },
      }
    end,
  },
}
