return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "aaronhallaert/advanced-git-search.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<C-e>", "<cmd>Telescope frecency<cr>", desc = "Recent files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", desc = "Search word" },
      { "<leader>sW", "<cmd>Telescope grep_string<cr>", desc = "Search wide" },
      { "<leader>sp", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", desc = "Search project" },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in file" },
      { "<leader>sS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Search symbols" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Git buffer commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>sa", function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,
            search_file = vim.fn.expand("<cword>"),
          })
        end, desc = "Search all files" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local lga_actions = require("telescope-live-grep-args.actions")
      local trouble = require("trouble.providers.telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          multi_icon = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            ".cache",
            "%.o",
            "%.a",
            "%.out",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = trouble.open_with_trouble,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.to_fuzzy_refine,
              ["<C-h>"] = "which_key",
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              ["<C-space>"] = actions.toggle_selection,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = trouble.open_with_trouble,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["?"] = actions.which_key,
              ["<space>"] = actions.toggle_selection,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          live_grep = {
            theme = "dropdown",
            previewer = true,
            additional_args = function()
              return { "--hidden" }
            end,
          },
          grep_string = {
            theme = "dropdown",
            previewer = true,
            word_match = "-w",
            only_sort_text = true,
            search = '',
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-h>"] = lga_actions.quote_prompt({ postfix = " -t" }),
              },
            },
          },
          frecency = {
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
            workspaces = {
              ["conf"] = "/Users/maririn312/.config",
              ["project"] = "/Users/maririn312/projects",
            },
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "live_grep_args")
      pcall(telescope.load_extension, "frecency")
      pcall(telescope.load_extension, "advanced_git_search")

      -- Set up custom commands
      vim.api.nvim_create_user_command("LiveGrepGitRoot", function()
        local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.v.shell_error == 0 then
          require("telescope.builtin").live_grep({
            cwd = git_dir,
          })
        else
          require("telescope.builtin").live_grep()
        end
      end, {})
    end,
  },
}
