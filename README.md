# HackMD plugin

Official HackMD plugin for agent hosts that speak MCP (ChatGPT, Codex, Claude Code, Cursor). Connects to HackMD through OAuth MCP and ships skills for publishing and visualization.

OpenAI Plugins Directory and Anthropic's Claude Code community marketplace are **separate listings**. Approval on one does not transfer to the other.

## What it does

| Capability | How |
| --- | --- |
| Read and write HackMD notes | MCP at `https://mcp.hackmd.io/` (OAuth) |
| Folders and book notes | MCP folder tools + `hackmd://guides/book` resource |
| Push Markdown or HTML | `push-to-hackmd` skill |
| Turn a discussion into an HTML note | `visualize-hmd` skill |

## Requirements

- HackMD account at [hackmd.io](https://hackmd.io)
- A host that can run remote MCP (ChatGPT Developer Mode / Plugins Directory, Codex, Claude Code, or Cursor)
- No API token for MCP. OAuth runs in the browser on first use.

## Install

### ChatGPT / Codex (OpenAI Plugins Directory)

After publication, search **HackMD** in the Plugins Directory shared by ChatGPT and Codex. Until then, connect the remote MCP in ChatGPT Developer Mode:

1. Settings → Security and login → Developer mode
2. Plugins → add MCP server `https://mcp.hackmd.io/`
3. Complete HackMD OAuth

Maintainer listing fields: [OPENAI-SUBMISSION.md](OPENAI-SUBMISSION.md).

### Claude Code

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

1. Enable the plugin (or add the MCP server).
2. Call any HackMD MCP tool, or ask the model to list your notes.
3. The host opens HackMD OAuth in the browser. Approve access.
4. MCP endpoint: `https://mcp.hackmd.io/` (set in `.mcp.json`; OpenAI With MCP submissions enter this URL in the portal).

Public HackMD MCP setup docs may still describe API tokens and `mcp-remote`. The current production path is OAuth to `https://mcp.hackmd.io/`.

## Example prompts

Copy one of these after the plugin is enabled and OAuth has completed. Each prompt is written so a reviewer can judge success from a single URL or a short list — no extra files, no local disk, no date filters the MCP server does not expose. The first three are the OpenAI listing starters (≤128 characters, one line).

**1. Read (OAuth + history + `get-note`)**

```
List my recent HackMD notes, read up to 3 with get-note, and summarize each in two sentences. Do not create or edit notes.
```

**2. Write Markdown (`create-note`)**

```
Create a HackMD note titled Verona 5-day itinerary: Markdown plan, 5 days, morning/afternoon/evening. Reply with title and URL.
```

**3. Visualize (`visualize-hmd` + `create-note`)**

```
Create a one-page HTML/CSS (no JS) comparing Markdown vs visual trip overviews; upload as a HackMD note and return the URL.
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

`visualize-hmd` applies when the user wants a one-page or webpage-style visual artifact. If they only want a text summary and do not mention a page, do not invoke it. ChatGPT Chat must emit HackMD-safe markup and call MCP directly — do not require `python3` or `/tmp`.

## Hooks (diff-before-patch)

| Event | Matcher | Behavior |
| --- | --- | --- |
| `PostToolUse` | `mcp__hackmd__get.*` | Write a baseline marker for `noteId` |
| `PreToolUse` | `mcp__hackmd__update.*` | Deny update if no marker. Consume marker on allow (one get per update). |

Deny output uses Codex `hookSpecificOutput` shape. **ChatGPT Chat does not run hooks**; skills still require `get-note` before every update. Codex / ChatGPT Work skip bundled hooks until the user trusts them.

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

Docs and contact: [HackMD tutorials](https://hackmd.io/s/tutorials) (support@hackmd.io).

## Layout

```
.
├── .claude-plugin/plugin.json
├── .codex-plugin/plugin.json
├── .mcp.json
├── skills/
│   ├── hackmd-mcp-usage/      # MCP policy + reference/
│   ├── push-to-hackmd/        # publish + reference/
│   └── visualize-hmd/         # viz; optional scripts/to-hackmd.py
├── hooks/
│   └── scripts/
│       ├── mark-baseline.sh
│       └── guard-update-note.sh
├── README.md
├── OPENAI-SUBMISSION.md
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

- OpenAI (ChatGPT / Codex): [OPENAI-SUBMISSION.md](OPENAI-SUBMISSION.md) — submit as **With MCP**, not Skills-only.
- Anthropic (Claude Code): [SUBMISSION.md](SUBMISSION.md) — [platform.claude.com/plugins/submit](https://platform.claude.com/plugins/submit).

## License

MIT. See [LICENSE](LICENSE).
