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
  major=$(echo "$version_output" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | cut -d'.' -f1 | tr -d 'v')
  minor=$(echo "$version_output" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | cut -d'.' -f2)
  if [[ -z "$major" || -z "$minor" ]]; then
    error "Could not parse Neovim version from: $version_output"
  fi
  if [[ "$major" -eq 0 && "$minor" -lt 9 ]]; then
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
