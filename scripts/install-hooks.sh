#!/bin/bash
# install-hooks.sh - Install stuffolio-site git hooks into .git/hooks/.
#
# Run this once per fresh clone. Re-run to pick up hook updates.
# The hooks themselves live under scripts/git-hooks/ so they ride with the
# repo; this installer just symlinks them into .git/hooks/.
#
# macOS Bash 3.2 compatible.

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_SRC="$REPO_ROOT/scripts/git-hooks"
HOOKS_DST="$REPO_ROOT/.git/hooks"

if [ ! -d "$HOOKS_DST" ]; then
  echo "install-hooks: $HOOKS_DST does not exist — is this a git repo?" >&2
  exit 1
fi

for hook in "$HOOKS_SRC"/*; do
  [ -f "$hook" ] || continue
  name=$(basename "$hook")
  target="$HOOKS_DST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "install-hooks: $target exists and is not a symlink — moving to ${target}.bak"
    mv "$target" "${target}.bak"
  fi

  ln -sf "$hook" "$target"
  chmod +x "$hook"
  echo "install-hooks: $name -> $hook"
done

echo "install-hooks: done. Hooks active in .git/hooks/."
