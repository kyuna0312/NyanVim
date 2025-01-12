return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "BufRead" },
    dependencies = {
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      -- Ensure Copilot is loaded before configuring
      vim.defer_fn(function()
        require("copilot").setup({
          panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
              jump_prev = "[[",
              jump_next = "]]",
              accept = "<CR>",
              refresh = "gr",
              open = "<M-CR>",
            },
            layout = {
              position = "right",
              ratio = 0.4,
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept = "<M-l>",
              accept_word = "<M-w>",
              accept_line = "<M-]>",
              next = "<M-]>",
              prev = "<M-[>",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            TelescopePrompt = false,
            markdown = false,
            help = false,
            gitcommit = false,
            gitrebase = false,
            hgcommit = false,
            svn = false,
            cvs = false,
            ["."] = false,
          },
          copilot_node_command = 'node',
          server_opts_overrides = {
            trace = "verbose",
            settings = {
              advanced = {
                listCount = 10,
                inlineSuggestCount = 3,
              },
            },
          },
        })
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup({
        formatters = {
          label = require("copilot_cmp.format").format_label_text,
          insert_text = require("copilot_cmp.format").format_insert_text,
          preview = require("copilot_cmp.format").deindent,
        },
      })
    end,
  },
}
