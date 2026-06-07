# NyanVim craftzdog-style Refactor + Claude Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure NyanVim into a craftzdog-style one-concern-per-file lazy.nvim config that actually imports its `plugins/` dir, resurrect the dead NyanVim dashboard, delete the dead-file graveyard, and add in-editor Claude integration — without losing branding or breaking the working setup.

**Architecture:** Today `config/lazy.lua` holds a 319-line inline `lazy.setup` table and never imports `lua/plugins/`, so all 38 files there (incl. the nyan dashboard) are dead. We migrate the *proven inline specs* into curated `lua/plugins/*.lua` files, delete the dead duplicates, then flip `lazy.lua` to a thin `{ import = "plugins" }` loader. Personal modules live in `lua/nyanvim/` (mirrors craftzdog's `lua/craftzdog/`). Claude is `coder/claudecode.nvim`.

**Tech Stack:** Neovim 0.12.2 (AppImage at `~/.local/bin/nvim`), lazy.nvim, mason + nvim-lspconfig (vim.lsp.config API), nvim-cmp, telescope, nvim-tree, treesitter, which-key v3, coder/claudecode.nvim + folke/snacks.nvim.

**Conventions:**
- `nvim` below means `~/.local/bin/nvim` (the 0.12.2 build). If your PATH already resolves nvim to it, plain `nvim` is fine — verify with `nvim --version | head -1` → `NVIM v0.12.2`.
- "Headless-clean" check: `cd ~/.config/nvim && nvim --headless +qa 2>&1` prints **nothing**. Any output = a regression to fix before moving on.
- Branch: `refactor/craftzdog-style-claude` (already checked out). Rollback anytime: `git reset --hard nyanvim-working-backup`.

**Keep set** (the only `lua/plugins/*.lua` files that survive): `colorscheme.lua`, `ui.lua`, `dashboard.lua`, `telescope.lua`, `lsp.lua`, `treesitter.lua`, `editor.lua`, `which-key.lua`, `claudecode.lua`. Everything else in `lua/plugins/` is deleted in Task 8.

---

## File Structure (end state)

```
init.lua                       -- + require("nyanvim.discipline").cowboy()
lua/
  config/
    lazy.lua                   -- REWRITTEN: bootstrap + { import = "plugins" }
    options.lua                -- unchanged
    keymaps.lua                -- unchanged
    autocmds.lua               -- unchanged
    which-key.lua              -- unchanged (v3, + Claude group added Task 9)
  nyanvim/
    init.lua                   -- unchanged (util module)
    health.lua                 -- unchanged
    discipline.lua             -- NEW (hjkl/arrow discipline)
  plugins/
    colorscheme.lua            -- NEW: tokyonight (active) + solarized-osaka (selectable)
    ui.lua                     -- NEW: nvim-tree, lualine, bufferline, illuminate, indent-blankline
    dashboard.lua              -- KEPT (resurrected nyan dashboard)
    telescope.lua              -- NEW: telescope + fzf/ui-select/projects/neoclip
    lsp.lua                    -- NEW: mason + lspconfig (vim.lsp.config) + cmp
    treesitter.lua             -- NEW: treesitter master branch + highlight/indent
    editor.lua                 -- NEW: gitsigns, toggleterm, autopairs, comment, todo, diffview, lazygit, project, neoclip
    which-key.lua              -- NEW: which-key spec (loads config.which-key)
    claudecode.lua             -- NEW: coder/claudecode.nvim + <leader>a* keys
docs/superpowers/{specs,plans} -- design + this plan
```

**Note on ordering:** new files are created *first* while still dormant (importer not yet enabled → inline block stays authoritative → config keeps working). Only Task 7 flips the importer, in one verified switch. This keeps a working editor through the whole migration.

---

### Task 1: Add solarized-osaka + tokyonight to a curated `colorscheme.lua`

**Files:**
- Create/overwrite: `lua/plugins/colorscheme.lua`

- [ ] **Step 1: Write the file**

```lua
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
```

- [ ] **Step 2: Lua-syntax check (file is dormant; not imported yet)**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/colorscheme.lua" +qa 2>&1`
Expected: no output (returns a table, no error).

- [ ] **Step 3: Headless-clean check (inline config still active)**

Run: `~/.local/bin/nvim --headless +qa 2>&1`
Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/colorscheme.lua
git commit -m "refactor(plugins): curated colorscheme.lua (tokyonight + solarized-osaka)"
```

---

### Task 2: Curated `ui.lua` (explorer + statusline + bufferline + polish)

**Files:**
- Create/overwrite: `lua/plugins/ui.lua`

- [ ] **Step 1: Write the file** (specs lifted verbatim from current inline `config/lazy.lua` lines 36–72, 276–277)

```lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        filters = { dotfiles = true },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = "|",
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
        },
      })
    end,
  },
  { "RRethy/vim-illuminate" },
  { "lukas-reineke/indent-blankline.nvim" },
}
```

- [ ] **Step 2: Lua-syntax check**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/ui.lua" +qa 2>&1`
Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/ui.lua
git commit -m "refactor(plugins): curated ui.lua (nvim-tree, lualine, bufferline, illuminate, indent)"
```

---

### Task 3: Curated `telescope.lua` (finder + all extensions)

**Files:**
- Create/overwrite: `lua/plugins/telescope.lua`

- [ ] **Step 1: Write the file** (merges inline specs at lines 90–108 and 282–292 into one spec; dedupes the two telescope blocks)

```lua
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
      "AckslD/nvim-neoclip.lua",
      "nvim-telescope/telescope-project.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "projects")
      pcall(require("telescope").load_extension, "neoclip")
    end,
  },
}
```

- [ ] **Step 2: Lua-syntax check**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/telescope.lua" +qa 2>&1`
Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/telescope.lua
git commit -m "refactor(plugins): curated telescope.lua with fzf/ui-select/projects/neoclip"
```

---

### Task 4: Curated `lsp.lua` (mason + lspconfig + cmp — proven code)

**Files:**
- Create/overwrite: `lua/plugins/lsp.lua`
- Reference: `git show nyanvim-working-backup:lua/config/lazy.lua` (lines 111–214 = the working nvim-lspconfig spec, including the `vim.lsp.config`/`vim.lsp.enable` migration and the full `cmp.setup` block with Tab/S-Tab mappings).

- [ ] **Step 1: Extract the working spec into the file**

Take the entire `{ "neovim/nvim-lspconfig", … }` table currently in `config/lazy.lua` (lines 111–214) and wrap it as the sole element of a returned list. Do NOT retype the `config = function() … end` body — copy it verbatim to avoid breaking the cmp Tab logic. Result shape:

```lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      -- >>> paste lines 126–213 of nyanvim-working-backup:lua/config/lazy.lua verbatim <<<
      -- (mason.setup, mason-lspconfig.setup{ensure_installed=…},
      --  vim.lsp.config('*'/'lua_ls'), vim.lsp.enable(servers),
      --  cmp.setup{ snippet/window/formatting/mapping/sources })
    end,
  },
}
```

Practical extraction command (writes the spec body to inspect, then hand-assemble):
`git show nyanvim-working-backup:lua/config/lazy.lua | sed -n '111,214p'`

- [ ] **Step 2: Lua-syntax check**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/lsp.lua" +qa 2>&1`
Expected: no output. (A `module 'cmp' not found` style error here would mean you accidentally executed the config body — `luafile` only loads the returned table, so this should be clean.)

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "refactor(plugins): curated lsp.lua (mason + lspconfig vim.lsp.config + cmp)"
```

---

### Task 5: New `treesitter.lua` (currently unconfigured — the inline block only had a comment)

**Files:**
- Create/overwrite: `lua/plugins/treesitter.lua`

**Why master branch:** nvim-treesitter's `main` branch dropped the classic `require("nvim-treesitter.configs").setup{}` API. Pin `branch = "master"` so this proven config works on nvim 0.12.

- [ ] **Step 1: Write the file**

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "javascript",
          "typescript", "tsx", "json", "html", "css",
          "rust", "go", "bash", "markdown", "markdown_inline",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
```

- [ ] **Step 2: Lua-syntax check**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/treesitter.lua" +qa 2>&1`
Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/treesitter.lua
git commit -m "refactor(plugins): add working treesitter.lua (master branch)"
```

---

### Task 6: Curated `editor.lua` + `which-key.lua`

**Files:**
- Create/overwrite: `lua/plugins/editor.lua`
- Create/overwrite: `lua/plugins/which-key.lua`

- [ ] **Step 1: Write `lua/plugins/editor.lua`** (specs from inline lines 217–243, 248–260, 278–279, 293–318; duplicates of Comment/todo-comments collapsed)

```lua
return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = { delay = 200 },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = { border = "curved", winblend = 3 },
        shell = vim.o.shell,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          javascript = { "template_string" },
          java = false,
        },
      })
    end,
  },
  { "numToStr/Comment.nvim", config = true },
  { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim", config = true },
  { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "kdheepak/lazygit.nvim", dependencies = "nvim-lua/plenary.nvim" },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup()
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require("neoclip").setup()
    end,
  },
}
```

- [ ] **Step 2: Write `lua/plugins/which-key.lua`** (spec from inline lines 263–273)

```lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("config.which-key")
    end,
  },
}
```

- [ ] **Step 3: Lua-syntax check both**

Run:
```bash
~/.local/bin/nvim --headless "+luafile lua/plugins/editor.lua" +qa 2>&1
~/.local/bin/nvim --headless "+luafile lua/plugins/which-key.lua" +qa 2>&1
```
Expected: no output from either.

- [ ] **Step 4: Commit**

```bash
git add lua/plugins/editor.lua lua/plugins/which-key.lua
git commit -m "refactor(plugins): curated editor.lua + which-key.lua specs"
```

---

### Task 7: Add `claudecode.lua` (Claude integration)

**Files:**
- Create: `lua/plugins/claudecode.lua`

**API reference (coder/claudecode.nvim):** requires `folke/snacks.nvim`; `config = true`; commands `:ClaudeCode` (toggle), `:ClaudeCodeFocus`, `:ClaudeCodeSelectModel`, `:ClaudeCodeSend` (visual), `:ClaudeCodeAdd <file>`, `:ClaudeCodeTreeAdd` (from nvim-tree), `:ClaudeCodeDiffAccept`, `:ClaudeCodeDiffDeny`. Needs the `claude` CLI on PATH (already present); no API key.

- [ ] **Step 1: Write the file**

```lua
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>at", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file from tree" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
    },
  },
}
```

- [ ] **Step 2: Lua-syntax check**

Run: `~/.local/bin/nvim --headless "+luafile lua/plugins/claudecode.lua" +qa 2>&1`
Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add lua/plugins/claudecode.lua
git commit -m "feat(plugins): add coder/claudecode.nvim with <leader>a Claude keymaps"
```

---

### Task 8: Delete the dead graveyard

**Files:**
- Delete: every `lua/plugins/*.lua` NOT in the keep set.

Keep set: `colorscheme.lua ui.lua dashboard.lua telescope.lua lsp.lua treesitter.lua editor.lua which-key.lua claudecode.lua`.

- [ ] **Step 1: Delete dead files**

```bash
cd ~/.config/nvim/lua/plugins
for f in autoformat bufferline coding conform copilot dap debug disabled editor_old flutter indent lsp_old lspconfig lualine luasnip mason mini-move neotree nvim-cmp nvim-tree oil package-info search snacks terminal test tmux-nvim tmux twilight visual-multi window-picker zenmode; do
  rm -f "$f.lua"
done
```

(The list above is the dead set. `nvim-tree.lua`, `lualine.lua`, `bufferline.lua` are deleted because their plugins now live in `ui.lua`; `lsp.lua`/`lspconfig.lua` old versions are replaced by Task 4's `lsp.lua` which you already overwrote.)

- [ ] **Step 2: Verify exactly the keep set remains**

Run: `ls ~/.config/nvim/lua/plugins/`
Expected output (order may vary):
```
claudecode.lua  colorscheme.lua  dashboard.lua  editor.lua  lsp.lua  telescope.lua  treesitter.lua  ui.lua  which-key.lua
```
If any extra `.lua` remains, `rm` it. If any keep-set file is missing, STOP and recover it from a prior commit.

- [ ] **Step 3: Headless-clean check (importer still off → inline still active)**

Run: `~/.local/bin/nvim --headless +qa 2>&1`
Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add -A lua/plugins/
git commit -m "refactor(plugins): delete dead unimported graveyard, keep curated set"
```

---

### Task 9: Flip `config/lazy.lua` to the importer (THE SWITCH)

**Files:**
- Overwrite: `lua/config/lazy.lua`

- [ ] **Step 1: Replace the whole file**

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = { lazy = false }, -- preserve prior eager-load behavior
  checker = { enabled = false },
  change_detection = { notify = false },
})
```

- [ ] **Step 2: Sync plugins (installs claudecode, snacks, solarized-osaka, resurrects dashboard)**

Run: `~/.local/bin/nvim --headless "+Lazy! sync" +qa 2>&1 | tail -20`
Expected: lazy installs the new plugins and finishes; no Lua errors. (First run downloads; allow it to complete.)

- [ ] **Step 3: Headless-clean check (now loading from plugins/ files)**

Run: `~/.local/bin/nvim --headless +qa 2>&1`
Expected: no output.

- [ ] **Step 4: Assert key plugins + dashboard are now live**

Run:
```bash
~/.local/bin/nvim --headless "+lua vim.defer_fn(function() local p=require('lazy.core.config').plugins local function has(n) return p[n] and 'OK' or 'MISSING' end print('dashboard:', has('dashboard-nvim')) print('claudecode:', has('claudecode.nvim')) print('snacks:', has('snacks.nvim')) print('telescope:', has('telescope.nvim')) print('nvim-tree:', has('nvim-tree.lua')) print('solarized-osaka:', has('solarized-osaka.nvim')) print('Telescope cmd:', vim.fn.exists(':Telescope')) print('ClaudeCode cmd:', vim.fn.exists(':ClaudeCode')) vim.cmd('qa') end, 1500)" 2>&1
```
Expected: every plugin `OK`, `Telescope cmd: 2`, `ClaudeCode cmd: 2`.

- [ ] **Step 5: Commit**

```bash
git add lua/config/lazy.lua
git commit -m "refactor(config): replace inline lazy.setup with { import = 'plugins' } loader"
```

---

### Task 10: Add `nyanvim/discipline.lua` + load it

**Files:**
- Create: `lua/nyanvim/discipline.lua`
- Modify: `init.lua`

- [ ] **Step 1: Write `lua/nyanvim/discipline.lua`** (craftzdog's cowboy discipline)

```lua
local M = {}

function M.cowboy()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l", "+", "-" }) do
    local count = 0
    local timer = assert(vim.loop.new_timer())
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then
        count = 0
      end
      if count >= 10 and vim.bo.buftype ~= "nofile" then
        ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function()
            return count >= 10
          end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        timer:start(2000, 0, function()
          count = 0
        end)
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
```

- [ ] **Step 2: Load it from `init.lua`**

Current `init.lua` ends with:
```lua
vim.defer_fn(function()
  require("config.lazy") -- Load lazy.nvim and plugins
  require("config.keymaps")
  require("config.autocmds")
end, 0)
```
Change that block to:
```lua
vim.defer_fn(function()
  require("config.lazy") -- Load lazy.nvim and plugins
  require("config.keymaps")
  require("config.autocmds")
  require("nyanvim.discipline").cowboy()
end, 0)
```

- [ ] **Step 3: Headless-clean check**

Run: `~/.local/bin/nvim --headless +qa 2>&1`
Expected: no output.

- [ ] **Step 4: Verify discipline mapping is installed**

Run: `~/.local/bin/nvim --headless "+lua vim.defer_fn(function() local m=vim.fn.maparg('j','n'); print('j remapped:', (m~='' ) and 'yes' or 'no'); vim.cmd('qa') end, 1500)" 2>&1`
Expected: `j remapped: yes`.

- [ ] **Step 5: Commit**

```bash
git add lua/nyanvim/discipline.lua init.lua
git commit -m "feat(nyanvim): add craftzdog discipline (hjkl/arrow training)"
```

---

### Task 11: Register Claude group in which-key + final smoke test

**Files:**
- Modify: `lua/config/which-key.lua`

- [ ] **Step 1: Add the AI/Claude group**

In `lua/config/which-key.lua`, inside the `wk.add({ … })` call, add this entry alongside the other `group` lines (e.g. right after the `-- Code` block):

```lua
  -- AI / Claude
  { "<leader>a", group = "AI/Claude" },
```

(The individual `<leader>a*` keys are already described via the `desc` fields in `claudecode.lua`'s `keys`, so only the group label is needed here.)

- [ ] **Step 2: Headless-clean check**

Run: `~/.local/bin/nvim --headless +qa 2>&1`
Expected: no output.

- [ ] **Step 3: Full smoke assertion**

Run:
```bash
cd ~/.config/nvim
~/.local/bin/nvim --headless "+lua vim.defer_fn(function() local p=require('lazy.core.config').plugins local n=0 for _ in pairs(p) do n=n+1 end print('plugins:', n) local cfg=0 for _ in pairs(vim.lsp._enabled_configs or {}) do cfg=cfg+1 end print('lsp enabled:', cfg) print('Telescope:', vim.fn.exists(':Telescope'), 'NvimTree:', vim.fn.exists(':NvimTreeToggle'), 'ClaudeCode:', vim.fn.exists(':ClaudeCode'), 'Dashboard:', vim.fn.exists(':Dashboard')) vim.cmd('qa') end, 2000)" 2>&1
```
Expected: `plugins:` ≥ 9 groups' worth, `lsp enabled: 8`, all four command checks return `2`.

- [ ] **Step 4: Manual interactive smoke (human)**

Open `~/.local/bin/nvim` in a real terminal and confirm:
- NyanVim nyan-cat dashboard renders on launch.
- `<leader>ff` opens telescope find_files.
- `<leader>ft` toggles nvim-tree.
- `<leader>ac` opens a Claude Code split (claude CLI launches).
- Visually select lines, `<leader>as` → selection lands in Claude.
- `:colorscheme solarized-osaka` switches theme; `:colorscheme tokyonight-moon` switches back.
- Spam `j` ~12 times fast → "Hold it Cowboy!" notification (discipline working).

- [ ] **Step 5: Commit**

```bash
git add lua/config/which-key.lua
git commit -m "feat(which-key): register AI/Claude leader group"
```

---

### Task 12: Finish the branch

- [ ] **Step 1: Confirm clean + summarize diff**

```bash
cd ~/.config/nvim
~/.local/bin/nvim --headless +qa 2>&1   # expect: nothing
git log --oneline nyanvim-working-backup..HEAD
```

- [ ] **Step 2: Use superpowers:finishing-a-development-branch** to choose merge / PR / cleanup.

---

## Self-Review

**Spec coverage:**
- Flip loading model → Task 9. ✓
- Migrate inline → files → Tasks 1–7. ✓
- Delete dead graveyard → Task 8. ✓
- Dedup winners (nvim-tree/telescope/fixed-LSP) → Tasks 2,3,4 + Task 8. ✓
- Keep NyanVim identity (dashboard resurrected, nyanvim/ kept, which-key kept) → dashboard.lua in keep set (Task 8), Task 11. ✓
- Claude integration `<leader>a*` → Task 7 + Task 11. ✓
- solarized-osaka selectable → Task 1. ✓
- discipline.lua → Task 10. ✓
- Verify headless-clean after each step → every task. ✓
- Backup/rollback → header + tag `nyanvim-working-backup`. ✓

**Placeholder scan:** The only "paste verbatim" is Task 4's proven cmp/LSP config body, with exact source location (`git show nyanvim-working-backup:lua/config/lazy.lua` lines 126–213) and a `sed` command to extract it — intentional, to avoid retyping the Tab-completion logic. Not a vague placeholder.

**Type/name consistency:** Plugin keys used in assertions match lazy's plugin-name convention (`dashboard-nvim`, `claudecode.nvim`, `nvim-tree.lua`, `snacks.nvim`, `solarized-osaka.nvim`). Command checks (`:Telescope`, `:ClaudeCode`, `:NvimTreeToggle`, `:Dashboard`) match the plugins that provide them. Keep-set filenames are consistent across Tasks 1–9.
