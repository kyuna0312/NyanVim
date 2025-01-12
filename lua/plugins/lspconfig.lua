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

    -- TypeScript configuration
    lspconfig.tsserver.setup(vim.tbl_extend("force", default_config, {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      single_file_support = true,
    }))

    -- Golang configuration
    lspconfig.gopls.setup(vim.tbl_extend("force", default_config, {
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
    }))

    -- Setup other LSP servers with default config
    local servers = {
      "lua_ls",
      "pyright",
      "rust_analyzer",
    }

    for _, server in ipairs(servers) do
      lspconfig[server].setup(default_config)
    end
  end,
}
