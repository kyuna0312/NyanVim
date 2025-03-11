return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- LSP Configuration
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Default config for all LSP servers
    local default_config = {
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }

    -- Setup LSP servers with specific configurations
    local servers = {
      tsserver = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
        single_file_support = true,
      },
      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      },
      lua_ls = {},
      pyright = {},
      rust_analyzer = {},
    }

    for server, config in pairs(servers) do
      lspconfig[server].setup(vim.tbl_extend("force", default_config, config))
    end
  end,
}
