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

## Performance

Startup time is benchmarked on every release using `nvim --startuptime`.

Results live in [`docs/perf/`](docs/perf/) — one file per release, with mean/median/min/max and a comparison against the previous release.

**Run locally:**
```bash
./bench.sh --runs 10
```

Results are saved to `docs/perf/YYYY-MM-DD-VERSION.md`.
