#!/usr/bin/env bash
# Recreate symlinks from $HOME into this dotfiles repo.
# Idempotent: safe to re-run. Backs up any existing non-symlink target.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  # link <repo-relative-source> <absolute-target>
  local src="$DOTFILES/$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
    echo "backed up existing $target"
  fi
  ln -s "$src" "$target"
  echo "linked $target -> $src"
}

link "claude/skills/conclude-session" "$HOME/.claude/skills/conclude-session"

echo "done."
