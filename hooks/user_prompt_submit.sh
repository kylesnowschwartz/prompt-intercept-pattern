#!/usr/bin/env bash
#
# Prompt Intercept Pattern — UserPromptSubmit hook
#
# Intercepts /prompt-intercept-pattern, runs code, and blocks the API call.
# The stub command file exists only for /help discoverability.
#
# Input:  JSON on stdin (from Claude Code)
# Output: JSON on stdout (decision + reason shown to user)
#
# Requires: jq

set -euo pipefail

input="$(cat)"
prompt="$(echo "$input" | jq -r '.prompt // .user_prompt // ""')"

# Only handle our command — pass everything else through
case "$prompt" in
  /prompt-intercept-pattern*)
    ;;
  *)
    echo '{}'
    exit 0
    ;;
esac

# Parse arguments
args="${prompt#/prompt-intercept-pattern}"
args="${args# }"  # trim leading space

# ── Side effects ─────────────────────────────────────────────
# Put your work here: clipboard copy, file writes, API calls,
# notifications, etc. This code runs WITHOUT consuming an API
# turn. The "message" variable is shown to the user afterward.
#
# Example: copy args to clipboard
#   echo "$args" | pbcopy
#   message="Copied to clipboard: $args"
# ─────────────────────────────────────────────────────────────

if [ -z "$args" ]; then
  message="No arguments provided. Usage: /prompt-intercept-pattern [message]"
else
  message="Echoed: $args"
fi

# ── Block ────────────────────────────────────────────────────
# Output decision:"block" to prevent the API call.
# The "reason" value is displayed to the user.
# ─────────────────────────────────────────────────────────────
jq -n --arg reason "$message" '{
  decision: "block",
  reason: $reason
}'
