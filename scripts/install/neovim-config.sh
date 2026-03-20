#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

source "$REPO_DIR/scripts/utils.sh"

NVIM_CONFIG_SRC="$REPO_DIR/config/nvim"
NVIM_CONFIG_DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# --- Check Neovim ---
echo "==> Checking Neovim..."
if ! command -v nvim &> /dev/null; then
  echo "Error: neovim is not installed. Install it first (e.g. via install.sh) and re-run."
  exit 1
fi
echo "    Found: $(nvim --version | head -1)"

# --- Check dependencies ---
echo "==> Checking dependencies..."

required_cmds=(git rg fd)
optional_cmds=(curl tar gcc make tree-sitter)
missing_required=()
missing_optional=()

for cmd in "${required_cmds[@]}"; do
  if ! check_command "$cmd"; then
    missing_required+=("$cmd")
  fi
done

for cmd in "${optional_cmds[@]}"; do
  if ! check_command "$cmd"; then
    missing_optional+=("$cmd")
  fi
done

if [ ${#missing_required[@]} -gt 0 ]; then
  echo "Error: missing required dependencies: ${missing_required[*]}"
  echo "Install them (e.g. via scripts/install/terminal-tools.sh) and re-run."
  exit 1
fi

if [ ${#missing_optional[@]} -gt 0 ]; then
  echo "Warning: missing optional dependencies: ${missing_optional[*]}"
  echo "         Some Treesitter parsers may not compile correctly."
fi

echo "    Dependencies OK"

# --- Backup existing config ---
echo "==> Checking for existing Neovim config..."
if [ -d "$NVIM_CONFIG_DEST" ]; then
  backup="${NVIM_CONFIG_DEST}.bak.$(date +%Y%m%d-%H%M%S)"
  echo "    Backing up $NVIM_CONFIG_DEST -> $backup"
  mv "$NVIM_CONFIG_DEST" "$backup"
else
  echo "    No existing config found, skipping backup"
fi

# --- Copy config ---
echo "==> Copying Neovim config..."
cp -r "$NVIM_CONFIG_SRC" "$NVIM_CONFIG_DEST"
echo "    Installed to $NVIM_CONFIG_DEST"

# --- Install plugins ---
echo "==> Installing plugins (headless)..."
nvim --headless "+Lazy! sync" +qa
echo "    Plugins installed"

# --- Done ---
echo ""
echo "==> Neovim config installed successfully!"
echo ""
echo "Keybindings:"
echo "  <leader>e   — toggle Neo-tree file explorer"
echo "  <leader>ff  — find files (Telescope)"
echo "  <leader>fg  — live grep (Telescope)"
echo "  <leader>fb  — buffers (Telescope)"
echo "  <leader>fh  — help tags (Telescope)"
echo ""
echo "Tip: run :Lazy inside nvim to manage plugins."
echo ""
echo "To uninstall:"
echo "  rm -rf $NVIM_CONFIG_DEST"
echo "  rm -rf \${XDG_DATA_HOME:-\$HOME/.local/share}/nvim/lazy"
