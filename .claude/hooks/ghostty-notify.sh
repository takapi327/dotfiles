#!/bin/bash
# Claude Code Notification hook for Ghostty
# Sends desktop notifications using OSC 777 escape sequence

INPUT=$(cat)

TITLE=$(echo "$INPUT" | jq -r '.title // "Claude Code"')
MESSAGE=$(echo "$INPUT" | jq -r '.message // "Notification"')
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // ""')

# Set title and message based on notification type
case "$NOTIFICATION_TYPE" in
  "permission_prompt")
    TITLE="Claude Code - Permission Required"
    MESSAGE="Claude is waiting for your approval"
    ;;
  "idle_prompt")
    TITLE="Claude Code - Waiting"
    MESSAGE="Claude is waiting for input"
    ;;
esac

# Send OSC 777 notification to Ghostty via GPG_TTY
if [ -n "$GPG_TTY" ] && [ -w "$GPG_TTY" ]; then
    printf '\x1b]777;notify;%s;%s\x1b\\' "$TITLE" "$MESSAGE" > "$GPG_TTY"
fi

exit 0
