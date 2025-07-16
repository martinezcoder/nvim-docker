#!/usr/bin/env bash
set -e

# Detect Ruby version from workspace or user home
RUBY_VERSION=""
if [ -f /workspace/.ruby-version ]; then
  RUBY_VERSION=$(cat /workspace/.ruby-version | tr -d '[:space:]')
elif [ -f /workspace/.tool-versions ]; then
  RUBY_VERSION=$(grep '^ruby ' /workspace/.tool-versions | awk '{print $2}' | tr -d '[:space:]')
elif [ -f "$HOME/.ruby-version" ]; then
  RUBY_VERSION=$(cat "$HOME/.ruby-version" | tr -d '[:space:]')
elif [ -f "$HOME/.tool-versions" ]; then
  RUBY_VERSION=$(grep '^ruby ' "$HOME/.tool-versions" | awk '{print $2}' | tr -d '[:space:]')
fi

if [ -z "$RUBY_VERSION" ]; then
  echo "[entrypoint] ERROR: No Ruby version found in /workspace/.ruby-version, /workspace/.tool-versions, $HOME/.ruby-version, or $HOME/.tool-versions"
  exit 1
else
  echo "[entrypoint] Detected Ruby version: $RUBY_VERSION"
fi

# Load asdf
. /opt/asdf/asdf.sh
export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"

# Install Ruby version if not present
if ! asdf list ruby | grep -q "$RUBY_VERSION"; then
  echo "[entrypoint] Installing Ruby $RUBY_VERSION via asdf..."
  asdf install ruby $RUBY_VERSION
fi

# Set as global for this session
asdf global ruby $RUBY_VERSION

# Show Ruby version
ruby -v

echo "[entrypoint] Launching Neovim..."
exec nvim "$@" 