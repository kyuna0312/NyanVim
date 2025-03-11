return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    -- Fix permissions for the parser directory
    local parser_path = vim.fn.stdpath("data") .. "/tree-sitter"
    vim.fn.mkdir(parser_path, "p")
    vim.fn.system({"chmod", "755", parser_path})

    require("nvim-treesitter.install").prefer_git = true

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "bash", "markdown", "markdown_inline",
        "javascript", "typescript", "python",
        "html", "css", "json", "yaml",
      },
      sync_install = false,
      auto_install = false,
      ignore_install = {},
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 50000
        end,
      },
      indent = { enable = true },
      autotag = { enable = true },
      context_commentstring = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    })
  end,
}
