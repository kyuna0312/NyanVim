# NyanVim → craftzdog-style refactor + Claude integration

**Date:** 2026-06-07
**Branch:** `refactor/craftzdog-style-claude`
**Backup:** git tag `nyanvim-working-backup` (current working state, nvim 0.12.2)

## Goal

Restructure NyanVim to mirror craftzdog/dotfiles-public's clean lazy.nvim
layout, eliminate dead/duplicate config, and add in-editor Claude integration —
while preserving NyanVim's branding, dashboard, keymaps, and working behavior.

## Background / current state

- nvim upgraded apt 0.9.5 → AppImage **0.12.2** at `~/.local/bin/nvim`.
- LSP + which-key migrated to 0.11+ APIs; startup is clean.
- **Key problem:** `lua/config/lazy.lua` calls `require("lazy").setup({…inline
  319-line table…}, custom_plugins)` and **never imports `lua/plugins/`**.
  All ~38 files in `lua/plugins/` are dead code (duplicate explorers, fuzzy
  finders, LSP configs that never load). The live config is the inline block.

## Target structure (craftzdog parity)

```
lua/
  config/
    lazy.lua      -- bootstrap + lazy.setup({ spec = {{ import = "plugins" }}, … })
    options.lua   -- unchanged
    keymaps.lua   -- unchanged (+ claude keymaps optional here or in plugin)
    autocmds.lua  -- unchanged
    which-key.lua -- unchanged (v3, already fixed)
  nyanvim/        -- NyanVim namespace (mirrors lua/craftzdog/)
    init.lua, health.lua  -- branding/health, kept
    discipline.lua -- NEW: craftzdog hjkl-discipline (opt-in extra)
  plugins/        -- ONE concern per file, all actually imported
    ui.lua, dashboard.lua, telescope.lua, lsp.lua, cmp.lua,
    treesitter.lua, nvim-tree.lua, colorscheme.lua, claudecode.lua, …
```

## Work plan

1. **Branch + backup** — done (`nyanvim-working-backup`, branch created).
2. **Flip loading model** — rewrite `config/lazy.lua` to bootstrap + a thin
   `lazy.setup` with `{ import = "plugins" }`, keeping the `custom/plugins`
   scan. No inline specs remain in `lazy.lua`.
3. **Migrate inline → files** — move each inline spec from the old `lazy.lua`
   into a properly named `lua/plugins/<concern>.lua` returning a lazy spec.
   The fixed `vim.lsp.config` LSP block → `lua/plugins/lsp.lua`.
4. **Delete the dead graveyard** — remove the pre-existing unused
   `lua/plugins/*` duplicates that were never imported, keeping only the
   migrated, deduped set. One file per plugin/domain.
5. **Dedup winners** — file-explorer = **nvim-tree** (dashboard depends on its
   `:NvimTreeToggle`); fuzzy = **telescope**; LSP = migrated inline version.
   Drop neo-tree/oil/search/lspconfig duplicates.
6. **Keep NyanVim identity** — `lua/nyanvim/*`, dashboard art, branding,
   keymaps, which-key all preserved and still loaded.
7. **Add Claude** — `lua/plugins/claudecode.lua` with `coder/claudecode.nvim`.
   Keymaps under `<leader>a`:
   - `<leader>ac` toggle Claude terminal
   - `<leader>af` focus Claude
   - `<leader>as` send visual selection / current buffer to Claude
   - `<leader>aa` accept proposed diff, `<leader>ad` deny diff
   Registered in which-key as group "AI/Claude". Uses existing `claude` CLI
   on PATH (no API key).
8. **Optional extras (both approved):**
   - `craftzdog/solarized-osaka.nvim` added as a selectable colorscheme
     (NOT forced; NyanVim branding/dashboard unaffected).
   - `lua/nyanvim/discipline.lua` (hjkl/arrow spam training), loaded at startup.
9. **Verify** — after each step, `nvim --headless +qa` must be output-clean and
   `:checkhealth` must not regress. Final manual smoke list documented.

## Non-goals (YAGNI)

- No switch to LazyVim base distro (stays hand-rolled, craftzdog-style only).
- No colorscheme forced change — solarized-osaka is opt-in selectable.
- No rewrite of options/keymaps/autocmds beyond wiring Claude keys.
- No avante / API-key AI path.

## Risks & mitigation

- **Risk:** moving 319 lines of working inline specs into files introduces
  typos / load-order breakage. **Mitigation:** incremental migration, headless
  verify after each file; backup tag for instant rollback.
- **Risk:** `{ import = "plugins" }` picking up a stale/broken file. **Mitigation:**
  delete the graveyard in the same step the importer is enabled; lazy will only
  load what's present.
- **Risk:** claudecode.nvim version requires nvim ≥ 0.11 — satisfied (0.12.2).

## Success criteria

- `nvim --headless +qa` → no output (clean) on the refactored config.
- All current features work: dashboard, nvim-tree, telescope, LSP (8 servers),
  cmp, which-key, treesitter.
- `<leader>a*` controls a working Claude session inside nvim; selection-send and
  diff-accept function.
- `lua/plugins/` contains only live, imported, deduped files — no dead code.
- solarized-osaka selectable; discipline active.
