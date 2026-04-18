# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

NyanVim — personal Neovim config built on top of [LazyVim](https://www.lazyvim.org/). Not a plugin; not distributed. It's a config repo meant to be cloned to `~/.config/nvim`.

## Formatting

All Lua files use **stylua**. Config lives in `.stylua.toml` / `stylua.toml`:
- 2-space indent, 120 column width, Unix line endings, `AutoPreferDouble` quotes

Format before committing:
```bash
stylua lua/
```

No linter beyond stylua. No test suite.

## Architecture

```
init.lua                    # Entry point: sets leader=<Space>, loads config.options, then defers lazy+keymaps+autocmds
lua/config/
  options.lua               # All vim.opt settings (loaded eagerly)
  lazy.lua                  # lazy.nvim bootstrap + inline plugin specs (large file)
  keymaps.lua               # All keymaps (loaded deferred via vim.defer_fn)
  autocmds.lua              # Autocommands + user commands (SmartSplit, transparent bg, sidebar mgmt)
  which-key.lua             # which-key group labels
lua/plugins/                # Additional plugin specs loaded by lazy.nvim
  disabled.lua              # Overrides to disable LazyVim defaults (currently disables mini.pairs)
  *.lua                     # One file per plugin or feature area
lazyvim.json                # LazyVim extras enabled (lang servers, linting, etc.)
lsp-config.lua              # Stray file at root — not loaded by Neovim, can be ignored
```

**Loading order matters:** `options.lua` runs synchronously at startup. Everything else (`lazy.lua`, `keymaps.lua`, `autocmds.lua`) runs inside `vim.defer_fn(..., 0)` for faster startup.

## Plugin System

lazy.nvim is the plugin manager. Two places hold plugin specs:

1. **`lua/config/lazy.lua`** — inline specs for core plugins (LSP stack, theme, telescope, treesitter, etc.)
2. **`lua/plugins/*.lua`** — additional/override specs; each returns a table or list of tables

LazyVim extras (language support, linting) are declared in `lazyvim.json` and auto-loaded by LazyVim's plugin system.

To disable a LazyVim default plugin, add an entry to `lua/plugins/disabled.lua`:
```lua
return {
  { "plugin/name", enabled = false },
}
```

## Key Behaviors

- **Auto-format on save**: `BufWritePre` autocmd calls `vim.lsp.buf.format()` synchronously for every buffer.
- **Transparent background**: applied via `ColorScheme` autocmd and called immediately in `autocmds.lua`.
- **NvimTree always on right**: multiple autocmds enforce `wincmd L` + `vertical resize 35/40` on FileType/VimResized.
- **Copilot**: disabled for `TelescopePrompt`, `markdown`, `help`, `txt` filetypes; re-enabled on `InsertEnter`.

## LSP / Mason

Mason auto-installs: `lua_ls`, `pyright`, `tsserver`, `rust_analyzer`, `gopls`, `jsonls`, `html`, `cssls`.

Additional language servers come from LazyVim extras in `lazyvim.json` (Go, Java, TypeScript, Terraform, etc.).

## Key Keymaps (leader = `<Space>`)

| Key | Action |
|-----|--------|
| `<leader>ff` / `<C-p>` | Find files (Telescope) |
| `<leader>fg` / `<C-S-f>` | Live grep |
| `<leader>e` / `<C-b>` | Toggle NvimTree |
| `<leader>t` | Toggle terminal (float) |
| `<leader>f` | Format buffer (LSP) |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>cm` | Open Mason |
| `<S-h>` / `<S-l>` | Prev/next buffer |
| `<M-\>` | Copilot panel (insert) |
| `<M-]>` | Accept Copilot suggestion |
