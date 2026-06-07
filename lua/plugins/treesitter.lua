return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- main branch is the rewrite required for Neovim 0.12; the old master
    -- branch crashes on markdown code-fence injections (iter_matches now
    -- returns a list of nodes per capture, which master's predicates mishandle).
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      -- Parsers are installed/updated via :TSUpdate (which needs the
      -- `tree-sitter` CLI). We intentionally do NOT auto-install on startup:
      -- the parsers are already compiled, and calling install() every launch
      -- would recompile them and error when the CLI is absent.
      -- Highlighting starts per-buffer whenever a parser is available.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
