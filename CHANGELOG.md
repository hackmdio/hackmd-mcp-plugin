# Changelog

## 1.1.0 — 2026-08-26

### Removed

- `agentic-work-log` skill (Python dependency; remains in upstream hackmd-skills)
- CLI path: `hackmd-cli`, `safe-sync.sh`, `resolve-note.sh`, `ensure-cli.sh`, `publish-viz.sh`
- `scripts/` tree and clone-to-`~/.cursor/skills` install docs

### Changed

- `push-to-hackmd`, `visualize-hmd`: MCP-only publish via OAuth; hooks enforce diff-before-patch
- `hackmd-mcp-usage`: sibling skills section; image upload documented as REST fallback in `capability-gaps.md`
- README, VENDOR, SUBMISSION: single MCP path; no CLI or work-log references

## 1.0.0 — 2026-08-26

### Added

- OAuth MCP connection to `https://mcp.hackmd.io/`
- Skills: `hackmd-mcp-usage` (model-invoked, `user-invocable: false`), `push-to-hackmd`, `visualize-hmd`
- Hooks: PostToolUse baseline marker on `get-*`; PreToolUse deny on `update-*` without marker

### Changed (writing-great-skills rewrite)

- Skills rewritten: lean SKILL.md + `reference/` progressive disclosure
- `push-to-hackmd`: reference/ for destination and edge cases
- `visualize-hmd`: step sequence with crux → build → publish completion criteria

- `commands/connect.md` — OAuth docs live in README
- `agents/hackmd-assistant.md` — v1 has no custom agent

### Notes

- Public HackMD MCP documentation may still describe API-token setup; this release targets OAuth-native hosts.
