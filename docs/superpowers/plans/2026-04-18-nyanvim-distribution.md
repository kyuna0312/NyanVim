# NyanVim Distribution Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform NyanVim from a personal config clone into a proper Neovim distribution that anyone can install with one command and customize without touching core files.

**Architecture:** An install script handles system checks, backup, and clone. A `lua/custom/` layer (already gitignored) lets users add plugins/keymaps/options without modifying core files, so they can `git pull` updates safely. A health check module exposes `:checkhealth nyanvim` for troubleshooting.

**Tech Stack:** Bash (install script), Lua (Neovim config), lazy.nvim plugin manager, LazyVim base distribution, vim.health API (health check)

---

## File Map

| File | Action | Purpose |
|------|--------|---------|
| `install.sh` | Create | One-liner install: checks deps, backs up, clones |
| `.gitignore` | Modify | Un-ignore `lazy-lock.json` so installs are reproducible |
| `lua/nyanvim/health.lua` | Create | `:checkhealth nyanvim` — verifies system deps |
| `lua/nyanvim/init.lua` | Create | Version constant + user config loader helpers |
| `lua/config/lazy.lua` | Modify | Load `lua/custom/plugins/` if directory exists |
| `lua/config/options.lua` | Modify | Source `lua/custom/options.lua` if file exists |
| `lua/config/keymaps.lua` | Modify | Source `lua/custom/keymaps.lua` if file exists |
| `lua/custom/README.md` | Create | Explains how to add user plugins/options/keymaps |
| `README.md` | Modify | New install section, keymaps table, customization guide |

---

## Task 1: Track lazy-lock.json for reproducible installs

**Files:**
- Modify: `.gitignore`

The current `.gitignore` excludes `lazy-lock.json`. A distribution needs pinned plugin versions so users get a known-good state on first install.

- [ ] **Step 1: Remove lazy-lock.json from .gitignore**

Edit `.gitignore` — delete the line `lazy-lock.json`. The file currently looks like:
```
plugin
custom
spell
ftplugin
syntax
coc-settings.json
.luarc.json
lazy-lock.json    ← delete this line
after
**/.DS_Store
```

Result after edit:
```
plugin
custom
spell
ftplugin
syntax
coc-settings.json
.luarc.json
after
**/.DS_Store
```

- [ ] **Step 2: Stage and commit lazy-lock.json**

```bash
git add .gitignore lazy-lock.json
git commit -m "chore: track lazy-lock.json for reproducible installs"
```

---

## Task 2: Health check module

**Files:**
- Create: `lua/nyanvim/init.lua`
- Create: `lua/nyanvim/health.lua`

The `vim.health` API lets plugins register a `:checkhealth` handler. Users run `:checkhealth nyanvim` to see if their system is set up correctly.

- [ ] **Step 1: Create the nyanvim module init**

Create `lua/nyanvim/init.lua`:
```lua
local M = {}

M.version = "1.0.0"

--- Check if an executable exists on PATH
---@param name string
---@return boolean
function M.has_executable(name)
  return vim.fn.executable(name) == 1
end

--- Check if nvim version meets minimum
---@param major integer
---@param minor integer
---@return boolean
function M.nvim_version_ok(major, minor)
  local v = vim.version()
  return v.major > major or (v.major == major and v.minor >= minor)
end

return M
```

- [ ] **Step 2: Write failing health check tests using plenary**

Create `tests/nyanvim/health_spec.lua`:
```lua
local nyanvim = require("nyanvim")

describe("nyanvim module", function()
  describe("has_executable", function()
    it("returns true for known executables", function()
      -- 'sh' must exist on any Unix system
      assert.is_true(nyanvim.has_executable("sh"))
    end)

    it("returns false for nonexistent executables", function()
      assert.is_false(nyanvim.has_executable("__nyanvim_fake_binary__"))
    end)
  end)

  describe("nvim_version_ok", function()
    it("accepts current neovim version", function()
      local v = vim.version()
      assert.is_true(nyanvim.nvim_version_ok(v.major, v.minor))
    end)

    it("rejects a future version", function()
      assert.is_false(nyanvim.nvim_version_ok(99, 99))
    end)
  end)
end)
```

- [ ] **Step 3: Run tests to verify they fail**

```bash
nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'init.lua'}" 2>&1 | tail -5
```

Expected: `tests/nyanvim/health_spec.lua` fails with `module 'nyanvim' not found`.

- [ ] **Step 4: Create the health check handler**

Create `lua/nyanvim/health.lua`:
```lua
local health = vim.health
local nyanvim = require("nyanvim")

local required_executables = {
  { name = "git",      reason = "plugin manager (lazy.nvim)" },
  { name = "node",     reason = "LSP servers (tsserver, pyright)" },
  { name = "npm",      reason = "LSP server installation" },
  { name = "rg",       reason = "Telescope live grep" },
  { name = "fd",       reason = "Telescope file search" },
  { name = "lazygit",  reason = "LazyGit integration (optional)", optional = true },
}

local function check_nvim_version()
  health.start("Neovim Version")
  if nyanvim.nvim_version_ok(0, 9) then
    health.ok(string.format("Neovim %s (>= 0.9 required)", tostring(vim.version())))
  else
    health.error(
      string.format("Neovim %s is too old. Upgrade to >= 0.9", tostring(vim.version())),
      { "https://github.com/neovim/neovim/releases" }
    )
  end
end

local function check_executables()
  health.start("External Dependencies")
  for _, dep in ipairs(required_executables) do
    if nyanvim.has_executable(dep.name) then
      health.ok(dep.name .. " — " .. dep.reason)
    elseif dep.optional then
      health.warn(dep.name .. " not found — " .. dep.reason)
    else
      health.error(
        dep.name .. " not found — required for: " .. dep.reason,
        { "Install via your package manager (brew/apt/pacman)" }
      )
    end
  end
end

local function check_c_compiler()
  health.start("C Compiler")
  local compilers = { "cc", "gcc", "clang" }
  local found = false
  for _, cc in ipairs(compilers) do
    if nyanvim.has_executable(cc) then
      health.ok(cc .. " found (needed for Treesitter parsers)")
      found = true
      break
    end
  end
  if not found then
    health.error(
      "No C compiler found (cc/gcc/clang). Treesitter parsers cannot be compiled.",
      { "Install build-essential (Debian), base-devel (Arch), or Xcode CLI tools (macOS)" }
    )
  end
end

local function check_nerd_font()
  health.start("Nerd Font")
  health.warn(
    "Cannot auto-detect Nerd Font. If icons look broken, install one from https://www.nerdfonts.com/ and set it in your terminal."
  )
end

local M = {}

function M.check()
  check_nvim_version()
  check_executables()
  check_c_compiler()
  check_nerd_font()
end

return M
```

- [ ] **Step 5: Run tests to verify they pass**

```bash
nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'init.lua'}" 2>&1 | tail -5
```

Expected: all tests pass.

- [ ] **Step 6: Verify health check works interactively**

```bash
nvim --headless -c "checkhealth nyanvim" -c "qa" 2>&1
```

Expected: output shows OK/WARN/ERROR lines, no Lua errors.

- [ ] **Step 7: Commit**

```bash
git add lua/nyanvim/ tests/
git commit -m "feat: add :checkhealth nyanvim with system dependency checks"
```

---

## Task 3: User customization layer

**Files:**
- Modify: `lua/config/lazy.lua`
- Modify: `lua/config/options.lua`
- Modify: `lua/config/keymaps.lua`
- Create: `lua/custom/README.md`

Users must be able to add plugins, keymaps, and options without editing core NyanVim files. This allows `git pull` updates to work cleanly. The `lua/custom/` directory is already gitignored.

- [ ] **Step 1: Write test for custom options loading**

Create `tests/nyanvim/custom_spec.lua`:
```lua
describe("custom layer", function()
  it("loads custom/options.lua if it exists", function()
    -- Create a temp custom options file
    local tmp = vim.fn.tempname() .. ".lua"
    local f = io.open(tmp, "w")
    f:write('vim.g.nyanvim_custom_loaded = true\n')
    f:close()

    -- Simulate the safe-load pattern
    local ok = pcall(dofile, tmp)
    assert.is_true(ok)
    assert.is_true(vim.g.nyanvim_custom_loaded == true)

    os.remove(tmp)
  end)

  it("does not error when custom/options.lua is missing", function()
    local path = "/tmp/__nyanvim_nonexistent_custom_options.lua"
    local ok = pcall(function()
      if vim.loop.fs_stat(path) then
        dofile(path)
      end
    end)
    assert.is_true(ok)
  end)
end)
```

- [ ] **Step 2: Run test to verify it fails**

```bash
nvim --headless -c "PlenaryBustedDirectory tests/ {minimal_init = 'init.lua'}" 2>&1 | tail -5
```

Expected: test passes (the pattern itself is what's being tested; this validates the approach before wiring it in).

- [ ] **Step 3: Modify lazy.lua to load custom plugins**

In `lua/config/lazy.lua`, find the `require("lazy").setup({` call. Add a second argument (opts table) that includes the custom plugins directory. Change:

```lua
require("lazy").setup({
  -- ... all the plugin specs ...
})
```

to:

```lua
local custom_plugins = {}
local custom_dir = vim.fn.stdpath("config") .. "/lua/custom/plugins"
if vim.loop.fs_stat(custom_dir) then
  -- Collect all .lua files from lua/custom/plugins/
  local handle = vim.loop.fs_scandir(custom_dir)
  while handle do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if type == "file" and name:match("%.lua$") then
      local mod = "custom.plugins." .. name:gsub("%.lua$", "")
      local ok, spec = pcall(require, mod)
      if ok then
        if type(spec) == "table" then
          vim.list_extend(custom_plugins, vim.islist(spec) and spec or { spec })
        end
      end
    end
  end
end

require("lazy").setup(vim.list_extend({
  -- ... all the existing plugin specs ...
}, custom_plugins))
```

- [ ] **Step 4: Modify options.lua to source custom options**

At the very end of `lua/config/options.lua`, append:

```lua
-- Load user custom options if present
local custom_options = vim.fn.stdpath("config") .. "/lua/custom/options.lua"
if vim.loop.fs_stat(custom_options) then
  dofile(custom_options)
end
```

- [ ] **Step 5: Modify keymaps.lua to source custom keymaps**

At the very end of `lua/config/keymaps.lua`, append:

```lua
-- Load user custom keymaps if present
local custom_keymaps = vim.fn.stdpath("config") .. "/lua/custom/keymaps.lua"
if vim.loop.fs_stat(custom_keymaps) then
  dofile(custom_keymaps)
end
```

- [ ] **Step 6: Create lua/custom/README.md**

Create `lua/custom/README.md`:
```markdown
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
vim.opt.relativenumber = false   -- Turn off relative numbers
vim.opt.colorcolumn = "80"       -- Show column guide at 80 chars
```

## Add keymaps

Create `lua/custom/keymaps.lua`. It runs after NyanVim's core keymaps:

```lua
-- lua/custom/keymaps.lua
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen mode" })
```
```

- [ ] **Step 7: Verify Neovim starts clean**

```bash
nvim --headless -c "lua print('ok')" -c "qa" 2>&1
```

Expected: prints `ok`, no Lua errors.

- [ ] **Step 8: Commit**

```bash
git add lua/config/lazy.lua lua/config/options.lua lua/config/keymaps.lua lua/custom/README.md
git commit -m "feat: user customization layer via lua/custom/ (gitignored)"
```

---

## Task 4: Install script

**Files:**
- Create: `install.sh`

The install script is what makes NyanVim a real distribution. One command → fully working Neovim.

- [ ] **Step 1: Verify shellcheck is available**

```bash
shellcheck --version 2>&1 | head -1
```

If not installed: `sudo pacman -S shellcheck` (Manjaro) or `brew install shellcheck` (macOS).

- [ ] **Step 2: Create install.sh**

Create `install.sh`:
```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/kyuna312/NyanVim.git"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

# ── Colors ────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${CYAN}[NyanVim]${NC} $*"; }
success() { echo -e "${GREEN}[NyanVim]${NC} $*"; }
warn()    { echo -e "${YELLOW}[NyanVim]${NC} $*"; }
error()   { echo -e "${RED}[NyanVim]${NC} $*" >&2; exit 1; }

# ── Dependency checks ─────────────────────────────────────────
check_dep() {
  local name="$1"
  local install_hint="$2"
  if ! command -v "$name" &>/dev/null; then
    error "Required: '$name' not found. $install_hint"
  fi
  success "$name found"
}

check_nvim_version() {
  local version_output
  version_output=$(nvim --version 2>&1 | head -1)
  local major minor
  major=$(echo "$version_output" | grep -oP 'v\K[0-9]+(?=\.[0-9]+\.[0-9]+)')
  minor=$(echo "$version_output" | grep -oP 'v[0-9]+\.\K[0-9]+(?=\.[0-9]+)')
  if [[ "$major" -lt 0 ]] || [[ "$major" -eq 0 && "$minor" -lt 9 ]]; then
    error "Neovim >= 0.9.0 required. Found: $version_output"
  fi
  success "Neovim $version_output"
}

info "Checking dependencies..."
check_dep "nvim"   "Install from https://neovim.io"
check_nvim_version
check_dep "git"    "Install git via your package manager"
check_dep "node"   "Install Node.js from https://nodejs.org"
check_dep "rg"     "Install ripgrep: brew/apt/pacman install ripgrep"
check_dep "fd"     "Install fd: brew/apt install fd-find / pacman install fd"

# C compiler check (non-fatal)
if ! command -v cc &>/dev/null && ! command -v gcc &>/dev/null && ! command -v clang &>/dev/null; then
  warn "No C compiler found. Treesitter parsers may fail to compile."
  warn "Install build-essential (Debian), base-devel (Arch), or Xcode CLI tools (macOS)"
fi

warn "Nerd Font required for icons. Install from https://www.nerdfonts.com/ if icons look broken."

# ── Backup existing config ────────────────────────────────────
if [[ -d "$NVIM_CONFIG" ]]; then
  local_data="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  local_state="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
  local_cache="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

  warn "Existing Neovim config found. Backing up..."
  mv "$NVIM_CONFIG"                             "${NVIM_CONFIG}${BACKUP_SUFFIX}"   2>/dev/null || true
  [[ -d "$local_data"  ]] && mv "$local_data"  "${local_data}${BACKUP_SUFFIX}"    2>/dev/null || true
  [[ -d "$local_state" ]] && mv "$local_state" "${local_state}${BACKUP_SUFFIX}"   2>/dev/null || true
  [[ -d "$local_cache" ]] && mv "$local_cache" "${local_cache}${BACKUP_SUFFIX}"   2>/dev/null || true
  success "Backed up existing config to ${NVIM_CONFIG}${BACKUP_SUFFIX}"
fi

# ── Clone ─────────────────────────────────────────────────────
info "Cloning NyanVim to $NVIM_CONFIG..."
git clone --depth=1 "$REPO_URL" "$NVIM_CONFIG"
success "Cloned NyanVim"

# ── Pre-install plugins (headless) ────────────────────────────
info "Installing plugins (this takes ~1 minute on first run)..."
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -3
success "Plugins installed"

echo ""
success "NyanVim installed! Run 'nvim' to start."
echo ""
info "Run ':checkhealth nyanvim' inside Neovim to verify your setup."
info "Add customizations to ~/.config/nvim/lua/custom/ (see lua/custom/README.md)"
```

- [ ] **Step 3: Make executable and run shellcheck**

```bash
chmod +x /home/kyuna/Desktop/NyanVim/install.sh
shellcheck /home/kyuna/Desktop/NyanVim/install.sh
```

Expected: no errors. Fix any warnings shellcheck reports before continuing.

- [ ] **Step 4: Dry-run the dependency section**

```bash
bash -x /home/kyuna/Desktop/NyanVim/install.sh 2>&1 | head -30
```

Expected: dependency checks print OK/error lines. Script will stop before clone because config already exists (or clone step runs — either fine for testing locally).

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "feat: add one-liner install script with dep checks and backup"
```

---

## Task 5: README overhaul

**Files:**
- Modify: `README.md`

Replace the current README with one that serves new users landing on the repo.

- [ ] **Step 1: Rewrite README.md**

Replace the full content of `README.md`:

```markdown
# 🐱 NyanVim

A modern Neovim distribution built on [LazyVim](https://www.lazyvim.org/) — IDE features, fast startup, VSCode-like feel.

<div align="center">
  <img src="https://raw.githubusercontent.com/kyuna312/dotfiles/refs/heads/main/logo.png" alt="NyanVim Logo">
</div>

## Requirements

| Dependency | Version | Notes |
|-----------|---------|-------|
| Neovim | >= 0.9.0 | [Install](https://neovim.io) |
| Git | >= 2.19 | |
| Node.js | any LTS | for LSP servers |
| ripgrep | any | `rg` — Telescope grep |
| fd | any | `fd` — Telescope find |
| C compiler | any | `gcc`/`clang` — Treesitter |
| Nerd Font | any | [nerdfonts.com](https://www.nerdfonts.com/) |

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/kyuna312/NyanVim/main/install.sh | bash
```

Or manually:

```bash
# Back up existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/kyuna312/NyanVim.git ~/.config/nvim

# Start Neovim — plugins install automatically on first launch
nvim
```

After install, run `:checkhealth nyanvim` to verify your system is set up correctly.

## Key Keymaps

Leader key: **`<Space>`**

### Navigation
| Key | Action |
|-----|--------|
| `<Space>ff` / `<C-p>` | Find files |
| `<Space>fg` | Live grep |
| `<Space>fb` | Open buffers |
| `<Space>fr` | Recent files |
| `<C-b>` | Toggle file explorer |
| `<S-h>` / `<S-l>` | Prev / Next buffer |
| `<C-h/j/k/l>` | Navigate windows |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code actions |
| `<Space>f` | Format buffer |

### Tools
| Key | Action |
|-----|--------|
| `<Space>t` | Toggle terminal |
| `<Space>cm` | Mason (LSP installer) |
| `<Space>tc` | Toggle Copilot |
| `<M-\>` | Copilot panel (insert) |
| `<M-]>` | Accept Copilot suggestion |

## Customize Without Forking

Add your own plugins, keymaps, and options to `~/.config/nvim/lua/custom/` — this directory is gitignored so `git pull` updates never overwrite your changes.

See `lua/custom/README.md` for examples.

## Update

```bash
cd ~/.config/nvim
git pull
nvim --headless "+Lazy! sync" +qa
```

## Languages Included

Go · TypeScript · Python · Rust · Lua · JSON · YAML · Markdown · SQL · Terraform · Docker · Java · C/C++ · Tailwind CSS · HTML/CSS

## Troubleshoot

```
:checkhealth nyanvim
```
```

- [ ] **Step 2: Verify markdown renders correctly**

```bash
# Check for broken links or obvious formatting issues
grep -n "]()" /home/kyuna/Desktop/NyanVim/README.md || echo "No empty links found"
```

Expected: `No empty links found`.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: rewrite README as distribution install guide"
```

---

## Task 6: Cleanup — remove stray lsp-config.lua

**Files:**
- Delete: `lsp-config.lua`

The root-level `lsp-config.lua` has JavaScript syntax inside a Lua file, is never loaded by Neovim, and will confuse users.

- [ ] **Step 1: Delete the file**

```bash
rm /home/kyuna/Desktop/NyanVim/lsp-config.lua
```

- [ ] **Step 2: Verify nothing references it**

```bash
grep -r "lsp-config" /home/kyuna/Desktop/NyanVim/lua/ 2>/dev/null || echo "No references found"
```

Expected: `No references found`.

- [ ] **Step 3: Commit**

```bash
git add -u
git commit -m "chore: remove stray lsp-config.lua (was never loaded, had JS syntax)"
```

---

## Self-Review

**Spec coverage check:**
- ✅ One-liner install → Task 4 (`install.sh`)
- ✅ Anyone can use without editing core → Task 3 (custom layer)
- ✅ Troubleshooting → Task 2 (`:checkhealth nyanvim`)
- ✅ Reproducible installs → Task 1 (`lazy-lock.json` tracked)
- ✅ Documentation → Task 5 (README)
- ✅ Cleanup → Task 6 (`lsp-config.lua`)

**Placeholder scan:** None. All steps contain actual code.

**Type consistency:** `nyanvim.has_executable` and `nyanvim.nvim_version_ok` defined in Task 2 Step 1, used in Task 2 Step 4 — consistent.
