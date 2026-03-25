# Prompt Intercept Pattern

A Claude Code plugin that demonstrates **hook-intercepted commands** — slash commands that run code without consuming an API turn.

## The pattern

Normal slash commands send their content to Claude as a prompt. This pattern short-circuits that: a `UserPromptSubmit` hook intercepts the prompt, runs your code, and blocks the API call. Claude never sees it.

Three pieces:

1. **Stub command** (`commands/prompt-intercept-pattern.md`) — registers the command in `/help` with autocomplete. `disable-model-invocation: true` prevents programmatic invocation. The file body is never sent to Claude.
2. **Hook config** (`hooks/hooks.json`) — wires `UserPromptSubmit` to the bash script.
3. **Hook script** (`hooks/user_prompt_submit.sh`) — matches the command, does work, outputs `{"decision":"block","reason":"message for user"}`.

```
prompt-intercept-pattern/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── prompt-intercept-pattern.md   # stub for /help
└── hooks/
    ├── hooks.json                    # wires the hook
    └── user_prompt_submit.sh         # does the work
```

## Try it

```bash
claude --plugin-dir /path/to/prompt-intercept-pattern
```

Then type `/prompt-intercept-pattern hello world`. You'll see "Echoed: hello world" with no API call.

## Adapt it

Open `hooks/user_prompt_submit.sh` and find the **Side effects** section. Replace the echo logic with your own: clipboard copy, file writes, notifications, whatever. The `message` variable is displayed to the user.

To rename the command, update three places:

1. The filename and `name:` field in `commands/`
2. The `case` match in `user_prompt_submit.sh`
3. The `args` parameter strip in `user_prompt_submit.sh`

## When to use this

Any command where the work is a side effect and sending a prompt to Claude is waste:

- Copy text to clipboard
- Toggle a setting
- Send a notification
- Write to a file
- Hit an external API

## Requirements

- Claude Code with plugin support
- `jq` for JSON handling

## License

MIT
