return {
  -- Active theme: tokyonight-moon re-grounded on the H4CK3R//LUCY palette
  -- (Cyberpunk: Edgerunners, Lucy Kushinada) — same night-city navy,
  -- magenta/violet/cyan neons as the tmux/ghostty/kitty/wezterm configs.
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = false,
        terminal_colors = true,
        on_colors = function(c)
          -- ground
          c.bg = "#0a0a1a"
          c.bg_dark = "#070712"
          c.bg_float = "#0d0d1a"
          c.bg_popup = "#0d0d1a"
          c.bg_sidebar = "#0d0d1a"
          c.bg_statusline = "#0d0d1a"
          c.bg_highlight = "#1a1a2e"
          c.bg_visual = "#2a2444"
          c.border = "#45c2f0"
          -- text
          c.fg = "#c4d0e0"
          c.fg_dark = "#a0b0c4"
          c.fg_gutter = "#3a3a55"
          c.comment = "#5a6a7a"
          -- lucy neons
          c.blue = "#45c2f0"
          c.cyan = "#00e5ff"
          c.magenta = "#ff2a7a"
          c.purple = "#b967ff"
          c.green = "#7dff9e" -- strings: soft mint (full matrix green is too loud)
          c.green1 = "#00ff41" -- accents: matrix green
          c.yellow = "#ffa600"
          c.orange = "#ffc266"
          c.red = "#ff2a7a"
          c.red1 = "#ff4d6d"
        end,
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.cyan, bold = true }
          hl.WinSeparator = { fg = "#1a1a2e" }
          hl.TelescopeBorder = { fg = c.purple }
          hl.TelescopeSelection = { bg = "#2a2444" }
          hl.TelescopeMatching = { fg = c.cyan, bold = true }
        end,
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
