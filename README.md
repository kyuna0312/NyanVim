# 🐱 NyanVim

A modern, IDE-like Neovim configuration focused on speed and productivity.

<div align="center">
  <img src="https://raw.githubusercontent.com/kyuna312/dotfiles/refs/heads/main/logo.png" alt="NyanVim Logo">
</div>

## 🚀 Features

- **Performance**
  - Blazingly fast startup time
  - Optimized lazy-loading
  - Minimal core configuration

- **Development Tools**
  - 🧠 Intelligent code completion
  - 📦 LSP support with auto-installation
  - 🐛 Integrated debugging
  - 🌳 File explorer with Git integration
  - 🔍 Fuzzy finding (files, text, commands)

- **User Experience**
  - 🎨 Modern UI with Tokyo Night theme
  - 🎮 Familiar VSCode-like keybindings
  - 🔧 Easy customization

## 📋 Requirements

- Neovim >= 0.9.0
- Git >= 2.19.0
- [Nerd Font](https://www.nerdfonts.com/)
- Node.js
- ripgrep
- C compiler

## ⚡ Quick Install

### macOS

```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install dependencies
brew install neovim git node ripgrep fd
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

### Debian

```bash
# Add Neovim repository
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
# Install dependencies
sudo apt-get install neovim git nodejs npm ripgrep fd-find
```

### Linux

```bash
sudo pacman -S neovim git nodejs npm ripgrep fd
```

### Configuration

```bash
# Backup your existing Neovim configuration
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

```bash
# Clone NyanVim
git clone https://github.com/kyuna312/NyanVim.git ~/.config/nvim
# Remove the .git directory to make it your own
rm -rf ~/.config/nvim/.git
```

[Source: https://github.com/kyuna312/NyanVim]
