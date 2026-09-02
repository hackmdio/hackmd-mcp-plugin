# HackMD Claude Plugin

Official HackMD plugin for the [Claude Code](https://code.claude.com) community marketplace. Connects to HackMD through OAuth MCP and ships skills for publishing and visualization.

## What it does

| Capability | How |
| --- | --- |
| Read and write HackMD notes | MCP at `https://mcp.hackmd.io/` (OAuth) |
| Folders and book notes | MCP folder tools + `hackmd://guides/book` resource |
| Push local Markdown or HTML | `push-to-hackmd` skill |
| Turn a discussion into an HTML note | `visualize-hmd` skill |

## Requirements

- HackMD account at [hackmd.io](https://hackmd.io)
- Claude Code with plugin support
- No API token for MCP. OAuth runs in the browser on first use.

## Install and validate

```bash
/plugin marketplace add anthropics/claude-plugins-community
/plugin install hackmd@claude-community
```

Local development:

```bash
claude --plugin-dir ./hackmd
claude plugin validate ./hackmd
```

## OAuth

1. Enable the plugin.
2. Call any HackMD MCP tool, or ask Claude to list your notes.
3. The host opens HackMD OAuth in the browser. Approve access.
4. MCP endpoint: `https://mcp.hackmd.io/` (set in `.mcp.json`).

Public HackMD MCP setup docs may still describe API tokens and `mcp-remote`. The current production path is OAuth to `https://mcp.hackmd.io/` in Claude Code and Cursor.

## Skills

| Skill | Invocation | Purpose |
| --- | --- | --- |
| `hackmd-mcp-usage` | Model-invoked (`user-invocable: false`) | Cross-tool policy: diff-before-patch, structure-first, metadata discipline, capability-gap disclosure |
| `push-to-hackmd` | Model-invoked | Push, save, backup, or publish to HackMD; update an existing note. Details in `reference/`. |
| `visualize-hmd` | Model-invoked | Visualize or turn the discussion into a webpage; shareable one-page output for an audience; update an existing viz note |

### Routing

- User has a file to upload → `push-to-hackmd`, not `visualize-hmd`
- User wants HTML generated from the discussion → `visualize-hmd`
- User works through MCP tools only → `hackmd-mcp-usage` + server `instructions`

`visualize-hmd` applies when the user wants a one-page or webpage-style visual artifact. If they only want a text summary and do not mention a page, do not invoke it.

## Hooks (diff-before-patch)

| Event | Matcher | Behavior |
| --- | --- | --- |
| `PostToolUse` | `mcp__hackmd__get.*` | Write a baseline marker for `noteId` |
| `PreToolUse` | `mcp__hackmd__update.*` | Deny update if no marker. Consume marker on allow (one get per update). |

All write skills (`push-to-hackmd`, `visualize-hmd`) follow this policy.

## Known limitations

| Gap | Workaround |
| --- | --- |
| Invite links | HackMD UI; MCP `feedback` with `gap_type=invite_link` |
| Public publish | HackMD UI; `feedback` with `gap_type=publish` |
| Full-text search | MCP is title-only; use HackMD web UI for Algolia |
| Image upload | HackMD UI or REST API after the note exists (see `hackmd-mcp-usage/reference/capability-gaps.md`) |
| Offline editing | Not supported |

## Privacy

- Note content goes to `hackmd.io` only when you or the agent calls MCP.
- OAuth tokens are managed by the MCP host, not stored in this repo.

## Layout

```
hackmd/
├── .claude-plugin/plugin.json
├── .mcp.json
├── skills/
│   ├── hackmd-mcp-usage/      # MCP policy + reference/
│   ├── push-to-hackmd/        # publish + reference/
│   └── visualize-hmd/         # viz + scripts/to-hackmd.py
├── hooks/
│   └── scripts/
│       ├── mark-baseline.sh
│       └── guard-update-note.sh
```

v1 does not ship `commands/` or `agents/`. OAuth setup is covered above.

## Ownership

| Piece | Owner |
| --- | --- |
| `.mcp.json` | This repo. Endpoint: `https://mcp.hackmd.io/` |
| MCP tool descriptions, server `instructions` | `hackmd-mcp` server (DEV-2928, DEV-3033) |
| `hackmd-mcp-usage` | Mirrors workflow policy at the plugin skill layer |
| Content skills | Vendored from [hackmd-skills](https://github.com/hackmd-product/hackmd-skills). See [VENDOR.md](VENDOR.md). |

## Marketplace submission

See [SUBMISSION.md](SUBMISSION.md). Form: [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit)

## License

MIT. See [LICENSE](LICENSE).
