# Claude Code Notification System

A clean notification system for tmux and Claude Code that provides native macOS notifications and one-click navigation to specific tmux panes.

📖 **[Read the full blog post](https://quemy.info/2025-08-04-notification-system-tmux-claude.html)** for a detailed walkthrough of the architecture and implementation.

## Overview

This system allows you to:
- Get native macOS notifications when Claude Code needs attention
- Click notifications to jump directly to the correct tmux pane
- Manage notifications across multiple devices via Gotify
- Run multiple Claude Code sessions in parallel with proper context switching

## Requirements

- macOS (with adaptations for Linux)
- tmux
- Docker (for n8n)
- Homebrew
- Claude Code
- Ghostty terminal (or adapt for your terminal)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/aquemy/claude-notifier.git
cd claude-notifier
```

2. Copy scripts to your bin directory:
```bash
cp bin/* ~/bin/
chmod +x ~/bin/ghostty-notify-wrapper.sh ~/bin/go-tmux.sh
```

3. Update paths in the scripts to match your username:
```bash
sed -i '' 's/<your_username>/YOUR_USERNAME/g' ~/bin/*.sh
```

4. Install webhook configuration:
```bash
cp config/.hooks.json ~/.hooks.json
sed -i '' 's/<your_username>/YOUR_USERNAME/g' ~/.hooks.json
```

5. Install and configure the LaunchAgent:
```bash
cp config/com.github.adnanh.webhook.plist ~/Library/LaunchAgents/
sed -i '' 's/<your_username>/YOUR_USERNAME/g' ~/Library/LaunchAgents/com.github.adnanh.webhook.plist
launchctl load ~/Library/LaunchAgents/com.github.adnanh.webhook.plist
```

6. Add Claude hooks to your `~/.claude/settings.json` (see config/claude-hooks.json for the structure)

7. Set up n8n with Docker and import the workflow from `config/n8n-workflow.json`

8. Configure Gotify server and update the token in the n8n workflow

## Usage

1. Start services:
```bash
# Start n8n
docker run -d --name n8n -p 5678:5678 n8nio/n8n

# Webhook is started automatically via LaunchAgent
```

2. Run Claude Code in tmux:
```bash
tmux new-session -s project1
claude code
```

3. When Claude needs attention, you'll receive a notification. Click it to jump to the correct tmux pane.

## Configuration Files

- `bin/ghostty-notify-wrapper.sh` - Handles notification display via terminal-notifier
- `bin/go-tmux.sh` - Switches to the correct tmux pane when notification is clicked
- `config/.hooks.json` - Webhook configuration for handling notifications
- `config/com.github.adnanh.webhook.plist` - LaunchAgent for running webhook service
- `config/claude-hooks.json` - Claude Code hooks configuration (merge into ~/.claude/settings.json)
- `config/n8n-workflow.json` - n8n workflow for orchestrating notifications

## Customization

- Replace Ghostty with your terminal by modifying the osascript command in `go-tmux.sh`
- For Linux: Replace `terminal-notifier` with `notify-send` and `osascript` with `xdotool`
- Add Discord/Slack notifications by extending the n8n workflow

## Architecture

1. Claude Code triggers hooks on events (Notification, Stop)
2. Hooks send data to n8n webhook
3. n8n sends notifications to Gotify and local webhook
4. Local webhook triggers terminal-notifier
5. Clicking notification activates the correct tmux pane

## License

MIT

## Author

Alexandre Quemy