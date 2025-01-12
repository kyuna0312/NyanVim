![Maririn312](https://github.com/maririn312/dotfiles/blob/main/logo.png)

NyanVim is Lazy Vim Improved Projects.

## ✨ Features

- 🔥 Transform your Neovim into a full-fledged IDE
- 💤 Easily customize and extend your config with NvChad Custom [nvchad.nvim](https://nvchad.com/)
- 🚀 Blazingly fast
- 🧹 Sane default settings for options, autocmds, and keymaps
- 📦 Comes with a wealth of plugins pre-configured and ready to use

## ⚡️ Requirements

- NvChad LazyVim optimized version
- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- a [Nerd Font](https://www.nerdfonts.com/) **_(optional)_**
- a **C** compiler for `nvim-treesitter`. See [here](https://github.com/nvim-treesitter/nvim-treesitter#requirements)

## 🚀 Getting Started

<details><summary>Install the <a href="">Nyan Vim</a></summary>

- Make a backup of your current Neovim files:

  ```sh
  mv ~/.config/nvim ~/.config/nvim.bak
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
  ```

- Clone the starter

  ```sh
  git clone https://github.com/NyanLinux/NyanVim.git  ~/.config/nvim
  ```

- Remove the `.git` folder, so you can add it to your own repo later

  ```sh
  rm -rf ~/.config/nvim/.git
  ```

- Start Neovim!

  ```sh
  nvim
  ```

  Refer to the comments in the files on how to customize **NyanVim**.

</details>

# Neovim Keybindings Guide

## Basic Navigation
| Keybinding | Description |
|------------|-------------|
| `h/j/k/l` | Move left/down/up/right |
| `w` | Move forward by word |
| `b` | Move backward by word |
| `0` | Go to start of line |
| `$` | Go to end of line |
| `gg` | Go to start of file |
| `G` | Go to end of file |
| `{number}G` | Go to line number |
| `Ctrl-u` | Scroll half page up |
| `Ctrl-d` | Scroll half page down |

## Window Management
| Keybinding | Description |
|------------|-------------|
| `<C-h>` | Navigate to left window |
| `<C-j>` | Navigate to window below |
| `<C-k>` | Navigate to window above |
| `<C-l>` | Navigate to right window |
| `<C-x>2` | Split window horizontally (smart) |
| `<C-x>3` | Split window vertically |
| `<C-x>0` | Close current window |
| `<C-x>o` | Cycle through windows |
| `<M-1>` | Go to window 1 |
| `<M-2>` | Go to window 2 |
| `<M-3>` | Go to window 3 |
| `<M-4>` | Go to window 4 |

## Window Resizing
| Keybinding | Description |
|------------|-------------|
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |

## File Explorer (NvimTree)
| Keybinding | Description |
|------------|-------------|
| `<C-b>` | Toggle file explorer |
| `<C-S-e>` | Focus file explorer |
| `<leader>ef` | Find current file in explorer |
| `<leader>er` | Refresh explorer |
| `<leader>ec` | Collapse explorer |
| `<leader>e]` | Increase sidebar width |
| `<leader>e[` | Decrease sidebar width |

## Buffer Operations
| Keybinding | Description |
|------------|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all |

## Code Navigation & LSP
| Keybinding | Description |
|------------|-------------|
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `K` | Show hover documentation |
| `gi` | Go to implementation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `gr` | Show references |
| `<leader>f` | Format code |

## Search & Find
| Keybinding | Description |
|------------|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>h` | Clear search highlights |

## Text Editing
| Keybinding | Description |
|------------|-------------|
| `<` | Indent left (in visual mode) |
| `>` | Indent right (in visual mode) |
| `J` | Move text down (in visual mode) |
| `K` | Move text up (in visual mode) |

## Terminal
| Keybinding | Description |
|------------|-------------|
| `<leader>t` | Toggle terminal |
| `<C-\>` | Exit terminal mode |

## Tips for Newcomers
- `<leader>` key is typically the space bar
- Most commands start with `<leader>` key
- Use `:help` followed by a command to get more information
- In command descriptions:
  - `C` means Ctrl (e.g., `<C-b>` = Ctrl+b)
  - `S` means Shift (e.g., `<S-h>` = Shift+h)
  - `M` means Alt/Meta (e.g., `<M-1>` = Alt+1)

## Common Command Mode Operations
| Command | Description |
|---------|-------------|
| `:w` | Save file |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:q!` | Force quit without saving |
| `:help` | Open help |
| `:noh` | Clear search highlights |

## Visual Mode
- Press `v` to enter visual mode (character selection)
- Press `V` to enter visual line mode (line selection)
- Press `Ctrl-v` to enter visual block mode (column selection)
- Use navigation keys to select text
- Press `y` to copy (yank)
- Press `d` to cut (delete)
- Press `p` to paste after cursor
- Press `P` to paste before cursor

## Insert Mode
- Press `i` to insert before cursor
- Press `a` to insert after cursor
- Press `I` to insert at beginning of line
- Press `A` to insert at end of line
- Press `o` to insert new line below
- Press `O` to insert new line above
- Press `Esc` or `Ctrl-[` to exit insert mode

Remember:
- Press `Esc` to return to normal mode from any other mode
- Most commands can be preceded by a number to repeat them
- Use `:help` followed by any command to get more information
