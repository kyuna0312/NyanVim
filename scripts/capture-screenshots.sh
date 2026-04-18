#!/usr/bin/env bash
# capture-screenshots.sh — take NyanVim screenshots for README
# Requirements: grim (sudo pacman -S grim), wezterm
set -euo pipefail

REPO=$(git rev-parse --show-toplevel)
OUT="${REPO}/assets/screenshots"
mkdir -p "$OUT"

if ! command -v grim &>/dev/null; then
  echo "error: grim not found. Install: sudo pacman -S grim" >&2
  exit 1
fi

if ! command -v wezterm &>/dev/null; then
  echo "error: wezterm not found" >&2
  exit 1
fi

# Create a sample Lua file for LSP demo
DEMO_FILE=$(mktemp --suffix=.lua)
cat > "$DEMO_FILE" << 'LUA'
-- NyanVim LSP demo
local M = {}

---@param name string
---@return string
function M.greet(name)
  return "Hello, " .. name
end

local function setup()
  local lsp = require("lspconfig")
  lsp.lua_ls.setup({
    settings = {
      Lua = { diagnostics = { globals = { "vim" } } },
    },
  })
end

return M
LUA

PANE=""
cleanup() {
  [[ -n "$PANE" ]] && wezterm cli kill-pane --pane-id "$PANE" 2>/dev/null || true
  rm -f "$DEMO_FILE"
}
trap cleanup EXIT

send() {
  wezterm cli send-text --pane-id "$PANE" -- "$1"
}

shot() {
  local name="$1"
  sleep 2
  grim "${OUT}/${name}.png"
  echo "  saved: ${name}.png"
}

echo "Spawning NyanVim..."
PANE=$(wezterm cli spawn --new-window -- nvim)
sleep 6  # wait for dashboard + plugins

echo "1/5 Dashboard..."
shot "dashboard"

echo "2/5 IDE view with file explorer..."
send ":e ${DEMO_FILE}"$'\r'
sleep 1
send $'\x02'  # <C-b> = toggle nvim-tree
sleep 1
shot "ide-view"

echo "3/5 Telescope fuzzy finder..."
send $'\x1b'  # ESC to normal mode
sleep 0.3
send " ff"    # <Space>ff = find files
sleep 1
shot "telescope"

echo "4/5 LSP hover..."
send $'\x1b'$'\x1b'  # close telescope
sleep 0.5
send ":e ${DEMO_FILE}"$'\r'
sleep 1
# Position on function name and trigger hover
send "3G"    # go to line 3
sleep 0.3
send "K"     # hover
sleep 1
shot "lsp"

echo "5/5 Floating terminal..."
send $'\x1b'
sleep 0.3
send " t"    # <Space>t = toggle terminal
sleep 1
shot "terminal"

echo ""
echo "Screenshots saved to: ${OUT}/"
ls -1 "${OUT}/"
