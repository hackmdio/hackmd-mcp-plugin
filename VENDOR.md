# Vendored upstream: hackmd-skills

| Field | Value |
| --- | --- |
| Repository | https://github.com/hackmd-product/hackmd-skills |
| Pinned commit | `f69898db122438010454741b6a2deebb87d445df` |
| Sync date | 2026-08-26 |

## Included skills

- `push-to-hackmd/` — rewritten for MCP-only publish (upstream was CLI-first)
- `visualize-hmd/` — `to-hackmd.py` + `reference.md` from upstream; publish path is MCP-only

## Excluded from plugin

- `agentic-work-log/` — lives in upstream only; requires Python and session sync tooling outside this plugin
- `evals/` — development evaluation fixtures only
- `.git/` — not shipped
- Upstream `shared/` CLI scripts (`safe-sync.sh`, `resolve-note.sh`, `api.md`) — replaced by MCP + hooks

## Re-sync procedure

Manually diff upstream `visualize-hmd/scripts/to-hackmd.py` and `visualize-hmd/reference.md` (design tokens section only — publish section is plugin-specific). Upstream `push-to-hackmd` and `agentic-work-log` are not copied verbatim.

After sync:

1. Review diff
2. Bump plugin version in `.claude-plugin/plugin.json`
3. Update pinned commit SHA in this file

## Plugin-only additions (not in upstream)

- `skills/hackmd-mcp-usage/` — MCP workflow meta-skill (`user-invocable: false`)
- `skills/hackmd-mcp-usage/reference/` — progressive disclosure (workflow, gaps, parameters)
- `hooks/` — PostToolUse baseline marker + PreToolUse deny on update
- `.mcp.json` — OAuth endpoint
