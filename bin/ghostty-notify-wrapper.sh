#!/bin/bash
# Ghostty notification wrapper for Claude Code tmux notifications
# 
# Parameters:
# $1 = tmux_location (e.g., "session:0.0")
# $2 = tmux_session_name
# $3 = tmux_window_name
# $4 = project
# $5 = cwd
# $6 = transcript_path
# $7 = hook_event_name (e.g., "Stop", "Notification")
# $8 = session_id

/opt/homebrew/bin/terminal-notifier \
  -subtitle "🤖 Claude is $([ "$7" = "Stop" ] && echo "done" || echo "waiting")." \
  -title "tmux s:$2 w:$3" \
  -message "Project $4 - Session $8" \
  -execute "/usr/bin/curl -X POST 'http://localhost:9000/hooks/show-ghostty?tmux_location=$1'" \
  -sound default