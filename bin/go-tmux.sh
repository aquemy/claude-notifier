#!/bin/zsh
# Tmux pane switcher for Claude Code notifications
# Handles notification clicks to navigate to the correct tmux pane

# Log ALL output for debugging
LOG="/tmp/tmux-notifier.log"
exec >> $LOG 2>&1

echo "=== CLICK EVENT: $(date) ==="
echo "PWD: $(pwd)"
echo "SHELL: $SHELL"
echo "PATH: $PATH"
echo "USER: $USER"
echo "LOCATION: $1"

# Source zsh environment to ensure tmux is in PATH
source "$HOME/.zshenv" 2>/dev/null
source "$HOME/.zshrc" 2>/dev/null

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"

echo "FINAL PATH: $PATH"

TMUX=$(whence -p tmux || echo "/usr/local/bin/tmux")
echo "TMUX binary: $TMUX"

if [[ ! -x "$TMUX" ]]; then
  echo "ERROR: tmux not found or not executable at $TMUX"
  exit 1
fi

LOCATION="$1"

if [[ -z "$LOCATION" ]]; then
  echo "ERROR: No location provided"
  exit 1
fi

# Parse tmux location format: session:window.pane
if [[ "$LOCATION" =~ ^([^:]+):([0-9]+)(\.([0-9]+))?$ ]]; then
  SESSION="${match[1]}"
  WINDOW="${match[2]}"
  PANE="${match[4]}"
else
  echo "ERROR: Invalid format: $LOCATION"
  exit 1
fi

echo "Switching to: session=$SESSION, window=$WINDOW, pane=$PANE"

# Run tmux commands to switch to the target pane
"$TMUX" select-window -t "$SESSION:$WINDOW"
if [[ $? -ne 0 ]]; then
  echo "ERROR: tmux select-window failed"
else
  echo "OK: select-window succeeded"
fi

if [[ -n "$PANE" ]]; then
  "$TMUX" select-pane -t "$SESSION:$WINDOW.$PANE"
  if [[ $? -ne 0 ]]; then
    echo "WARNING: select-pane failed"
  else
    echo "OK: select-pane succeeded"
  fi
fi

# Try to focus Ghostty terminal
# Replace this with your terminal application
osascript -e 'tell application "Ghostty" to activate'
if [[ $? -eq 0 ]]; then
  echo "OK: osascript ran successfully"
else
  echo "ERROR: osascript failed with code $?"
fi

echo "=== END ==="