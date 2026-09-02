# Community Marketplace Submission Checklist

## Pre-submit validation

```bash
claude plugin validate ./hackmd --strict
```

## Submission form fields (draft)

| Field | Value |
| --- | --- |
| **Name** | hackmd |
| **Description** | Connect Claude to HackMD via OAuth MCP — notes, folders, books, publish, and visualize. |
| **Repository** | `hackmd-product/hackmd-claude-plugin` (create before submit) |
| **Homepage** | https://hackmd.io |
| **Category** | Productivity / Documentation |
| **Auth** | OAuth via `https://mcp.hackmd.io/` — no user API keys in plugin config |

## What PM ships vs Engineering

| Component | Owner | Status in this pack |
| --- | --- | --- |
| `.mcp.json` | Engineering review | ✅ OAuth URL `https://mcp.hackmd.io/` |
| `skills/` | PM (vendored + meta) | ✅ |
| `hooks/` | PM | ✅ PostToolUse marker + PreToolUse deny |
| MCP tool descriptions | Engineering (`hackmd-mcp`) | Server-side; DEV-3033 |
| Server `instructions` | Engineering | DEV-2928 |

## Review talking points

1. **OAuth-first** — aligns with Claude Desktop / Cursor native MCP; public HackMD docs not yet updated.
2. **Progressive disclosure** — `hackmd-mcp-usage` meta-skill for cross-tool policy; per-tool semantics on server.
3. **Safe editing** — diff-before-patch in skill + hook on every MCP update.
4. **Capability gaps disclosed** — invite, publish, full-text search, image upload documented in README and meta-skill.
5. **No telemetry in plugin** — server telemetry is separate (internal spec).

## Post-approval

- Pin commit SHA in `anthropics/claude-plugins-community` catalog
- Update public HackMD MCP docs to OAuth flow
- Archive duplicate standalone `visualize-hmd` repo per hackmd-skills README

## Related Linear project

[MCP Agent Experience](https://linear.app/hackmd-product/project/mcp-agent-experience-5e40c5dfe67e/overview)

Key issues reflected in plugin:

- DEV-2928 — server instructions (server-side; mirrored in `hackmd-mcp-usage`)
- DEV-3033 — metadata discipline
- DEV-2922 — folder tools
- DEV-2926 — `hackmd://guides/book`
- DEV-3034 — quota readable errors (server-side)

## Tool description quality (arxiv:2602.14878)

Meta-skill and README use compact four-part descriptions:

- Purpose
- Limitations
- Usage guidelines
- Parameter notes

Examples omitted per ablation findings (equivalent performance, lower token cost).
