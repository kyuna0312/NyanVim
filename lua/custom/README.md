# NyanVim Custom Layer

This directory is gitignored — your personal customizations live here and survive `git pull` updates.

## Add plugins

Create files in `lua/custom/plugins/`. Each file must return a lazy.nvim plugin spec:

```lua
-- lua/custom/plugins/my-plugin.lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({})
  end,
}
```

## Override options

Create `lua/custom/options.lua`. It runs after NyanVim's core options:

```lua
-- lua/custom/options.lua
vim.opt.relativenumber = false
vim.opt.colorcolumn = "80"
```

## Add keymaps

Create `lua/custom/keymaps.lua`. It runs after NyanVim's core keymaps:

```lua
-- lua/custom/keymaps.lua
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
```
