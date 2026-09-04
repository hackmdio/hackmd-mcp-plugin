# HackMD Claude Plugin

Official HackMD plugin for the [Claude Code](https://code.claude.com) community marketplace. Connects to HackMD through OAuth MCP and ships skills for publishing and visualization.

This repository is submitted to Anthropic's **plugin directory** (Claude Code: `hackmd@claude-community`). That directory is separate from the curated `claude-plugins-official` catalog, which Anthropic maintains at its discretion and has no application form.

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

Local development (this repository is the plugin root):

```bash
claude --plugin-dir .
claude plugin validate . --strict
```

## OAuth

1. Enable the plugin.
2. Call any HackMD MCP tool, or ask Claude to list your notes.
3. The host opens HackMD OAuth in the browser. Approve access.
4. MCP endpoint: `https://mcp.hackmd.io/` (set in `.mcp.json`).

Public HackMD MCP setup docs may still describe API tokens and `mcp-remote`. The current production path is OAuth to `https://mcp.hackmd.io/` in Claude Code and Cursor.

## Example prompts

Copy one of these into Claude after the plugin is enabled and OAuth has completed. Each prompt is written so a reviewer can judge success from a single URL or a short list — no extra files, no local disk, no date filters the MCP server does not expose.

**1. Read (OAuth + history + `get-note`)**

```
List the HackMD notes I opened recently (note history is enough). Pick at most 3, read each with get-note, and write a two-sentence summary. Do not create or edit any note.
```

**2. Write Markdown (`create-note`)**

```
Create a new HackMD note titled "Verona 5-day itinerary". Body: a Markdown plan for five days in Verona, Italy, with morning / afternoon / evening for each day. Do not add HTML or CSS. When done, reply with only the title and the note URL.
```

**3. Visualize (`visualize-hmd` + `create-note`)**

```
Create a single-page HTML/CSS visualization (no JavaScript) that compares two ways to share a trip on HackMD: a Markdown itinerary versus a one-page visual overview. Upload it as a new HackMD note, return the note URL, and remind me to enable Custom CSS preview.
```

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

See the [HackMD Privacy Policy](https://hackmd.io/s/privacy).

- Note content goes to `hackmd.io` only when you or the agent calls MCP.
- OAuth tokens are managed by the MCP host, not stored in this repo.

## Support

Product and security questions: [support@hackmd.io](mailto:support@hackmd.io).

## Layout

```
.
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
├── README.md
├── CHANGELOG.md
└── LICENSE
```

v1 does not ship `commands/` or `agents/`. OAuth setup is covered above.

## Ownership

| Piece | Owner |
| --- | --- |
| `.mcp.json` | This repo. Endpoint: `https://mcp.hackmd.io/` |
| MCP tool descriptions, server `instructions` | `hackmd-mcp` server |
| `hackmd-mcp-usage` | Mirrors workflow policy at the plugin skill layer |
| Content skills | Vendored from [hackmd-skills](https://github.com/hackmd-product/hackmd-skills). See [VENDOR.md](VENDOR.md). |

## Marketplace submission

Submit at [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit). Maintainer checklist: [SUBMISSION.md](SUBMISSION.md).

## License

MIT. See [LICENSE](LICENSE).
