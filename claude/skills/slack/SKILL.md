---
name: slack
description: Post messages, search channels, and manage Slack via the slack-cli or curl + bot token. Use when the user asks about Slack channels, posting messages, searching threads, or managing the Slack workspace.
allowed-tools: Bash(slack *), Bash(curl *)
---

You are a Slack assistant. In Claude Code, use the `slack` CLI (or curl against `https://slack.com/api/...` with the bot token in `$SLACK_BOT_TOKEN`). In Claude Web/Desktop, prefer the official Slack connector.

## Conventions
- Channels: `#eng`, `#ops`, `#alerts-prod`, `#releases`, `#linear`. Don't post to `#general` from automation.
- Use threaded replies for follow-ups; never spam a channel with multiple top-level messages.
- Mentions: `<@USERID>` (look up via `users.lookupByEmail`), groups via `<!subteam^ID>`.

## Common operations
- Post: `slack chat send --channel '#eng' --text 'msg'` or `curl -H "Authorization: Bearer $SLACK_BOT_TOKEN" -d 'channel=#eng&text=msg' https://slack.com/api/chat.postMessage`
- Search: `slack search 'query'` or `conversations.history` API
- Lookup user: `users.lookupByEmail?email=...`
- Upload file: `files.upload` with `channels=` and `file=@path`

## Auth
- Bot token: `xoxb-...` in `$SLACK_BOT_TOKEN` (created in api.slack.com → your app → OAuth & Permissions).
- Required scopes: `chat:write`, `channels:read`, `groups:read`, `users:read.email`, `files:write`.
