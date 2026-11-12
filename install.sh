#!/bin/zsh
# brooklyn installer
#   install:    curl -fsSL https://raw.githubusercontent.com/staSios2k/mac-lid-closed-no-sleep--till-brooklyn-/main/install.sh | zsh
#   uninstall:  curl -fsSL https://raw.githubusercontent.com/staSios2k/mac-lid-closed-no-sleep--till-brooklyn-/main/install.sh | zsh -s -- --uninstall
#
# Installs to ~/.local/bin. Never needs sudo to install.

set -e

REPO_RAW="https://raw.githubusercontent.com/staSios2k/mac-lid-closed-no-sleep--till-brooklyn-/main"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/brooklyn"
ZSHRC="$HOME/.zshrc"
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if [[ $(uname) != Darwin ]]; then
  print -u2 "brooklyn only works on macOS."
  exit 1
fi

if [[ ${1:-} == --uninstall ]]; then
  if [[ $(/usr/bin/pmset -g | awk '/SleepDisabled/ {print $2}') == 1 ]]; then
    print "Sleep is currently disabled. Restoring normal sleep (needs your password)..."
    sudo /usr/bin/pmset -a disablesleep 0
  fi
  rm -f "$TARGET" /tmp/brooklyn_timer.state 2>/dev/null || true
  print "brooklyn removed from $TARGET."
  print "You can delete this line from $ZSHRC if nothing else uses it:"
  print "  $PATH_LINE"
  exit 0
fi

mkdir -p "$BIN_DIR"

# Use the local copy when run from a cloned repo, otherwise download it.
SCRIPT_DIR=${0:A:h}
if [[ -f "$SCRIPT_DIR/brooklyn" && "$SCRIPT_DIR/brooklyn" != "$TARGET" ]]; then
  cp "$SCRIPT_DIR/brooklyn" "$TARGET"
else
  curl -fsSL "$REPO_RAW/brooklyn" -o "$TARGET"
fi

chmod +x "$TARGET"
xattr -c "$TARGET" 2>/dev/null || true

if [[ ":$PATH:" != *":$BIN_DIR:"* ]] && ! grep -qs '.local/bin' "$ZSHRC"; then
  print "\n$PATH_LINE" >> "$ZSHRC"
  print "Added ~/.local/bin to your PATH in $ZSHRC."
  print "Open a new Terminal window (or run: source ~/.zshrc) before using brooklyn."
fi

print "Installed $("$TARGET" --version) to $TARGET"
print "Try: brooklyn 1"
