#!/bin/bash
# Claude Code Stop hook for Ghostty
# Sends desktop notification when Claude finishes responding

INPUT=$(cat)

# Check if this is already a continuation from a stop hook to prevent infinite loops
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

# Send OSC 777 notification to Ghostty via GPG_TTY
if [ -n "$GPG_TTY" ] && [ -w "$GPG_TTY" ]; then
    printf '\x1b]777;notify;Claude Code;Task completed\x1b\\' > "$GPG_TTY"
fi

exit 0
