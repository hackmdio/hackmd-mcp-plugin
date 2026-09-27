# Changelog

## 1.2.0 — 2026-09-20

### Added

- `.codex-plugin/plugin.json` for OpenAI Plugins Directory (With MCP) listing fields, starter prompts, and HTTPS support URL
- [OPENAI-SUBMISSION.md](OPENAI-SUBMISSION.md): portal copy, 5 positive / 3 negative test cases, demo recording script

### Changed

- Neutral package copy: no “Connect Claude to HackMD” or Claude-only install path as the primary story
- `guard-update-note.sh` deny JSON uses Codex `hookSpecificOutput` (Claude Code accepts the same shape)
- Baseline markers prefer `PLUGIN_DATA` / `CLAUDE_PLUGIN_DATA` when set
- `visualize-hmd` publishes HackMD-safe markup via MCP without `/tmp` or `python3`; the script remains an optional Codex check
- Skills state that ChatGPT Chat does not run hooks, so every update still needs `get-note` first

## 1.1.1 — 2026-09-02

### Added

- README example prompts (read / Markdown create / HTML visualize) and a link to the [HackMD Privacy Policy](https://hackmd.io/s/privacy)
- Support contact on the README

### Fixed

- Git file mode for hook scripts and `to-hackmd.py` (`100755`) so marketplace installs can execute them
- Manifest `repository` URL and local `claude --plugin-dir` / `plugin validate` paths for a plugin-root repo

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
