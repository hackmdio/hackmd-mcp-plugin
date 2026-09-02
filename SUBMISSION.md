# Community Marketplace Submission Checklist

Maintainer notes for the Anthropic plugin directory form. Do not put passwords or session cookies in this file.

## Pre-submit validation

```bash
claude plugin validate . --strict
```

Scripts that hooks and `visualize-hmd` execute must be tracked as executable (`100755`):

```bash
git ls-tree HEAD hooks/scripts/mark-baseline.sh hooks/scripts/guard-update-note.sh skills/visualize-hmd/scripts/to-hackmd.py
```

## Submission form fields (draft)

| Field | Value |
| --- | --- |
| **Name** | hackmd |
| **Description** | Connect Claude to HackMD via OAuth MCP — notes, folders, books, publish, and visualize. |
| **Repository** | `hackmdio/hackmd-mcp-plugin` (must be **public** before submit) |
| **Homepage** | https://hackmd.io |
| **Privacy policy** | https://hackmd.io/s/privacy |
| **Support** | support@hackmd.io |
| **Category** | Productivity / Documentation |
| **Auth** | OAuth via `https://mcp.hackmd.io/` — no user API keys in plugin config |

## Example prompts (paste into the form)

1. 將目前的磁碟空間使用情況，用 HTML/CSS 圖解，將 HTML 內容上傳到 HackMD
2. 列出最近 7 天更新的筆記並摘要變更
3. 擬出「義大利 Verona 五日遊」的行程，以 Markdown 為主體，有需要可以用 HTML/CSS 輔助視覺呈現，上傳到 HackMD

## Reviewer test account

Anthropic asks for a **standard testing account with sample data** so a reviewer can run the plugin without emailing us. Credentials go **only** in the submission form (Test & launch / test-account fields), never in git.

### What to create

1. A dedicated HackMD user (not a staff daily-driver). Email + password is easier for reviewers than SSO-only.
2. Grant it a free or paid plan that can create notes (prompts 1 and 3 write new notes).
3. Seed data **before** you submit, so prompt 2 is not an empty list:

| Seed | Why |
| --- | --- |
| ≥3 notes whose last edit is within the last 7 days | Prompt 2 (recent updates) |
| ≥2 notes last edited more than 7 days ago | Prompt 2 has something to exclude |
| Distinct titles (mix of English and Chinese is fine) | Title-only search |
| One folder containing ≥2 of those notes | Folder tools |
| Optional: one team the test user can read/write | Team note tools, if exercised |

Suggested titles for the recent notes (edit them the day you submit, so `lastChanged` is fresh):

- `Review seed — project log`
- `Review seed — meeting notes`
- `Review seed — Verona research`

Leave the older notes untouched so the 7-day cut is visible.

### What to paste into the Anthropic form

- Login URL: `https://hackmd.io/login`
- Email and password of the test user
- One sentence: “OAuth to `https://mcp.hackmd.io/` as this user. Seed notes titled `Review seed — *` were edited in the last 7 days.”
- After review, rotate the password.

### What we cannot put in the repo

Passwords, magic links, backup codes, or a real user’s notes.

## Review talking points

1. **OAuth-first** — production path is `https://mcp.hackmd.io/`; no API token in plugin config.
2. **Progressive disclosure** — `hackmd-mcp-usage` for cross-tool policy; per-tool semantics on the server.
3. **Safe editing** — diff-before-patch in skill + hook on every MCP update.
4. **Capability gaps disclosed** — invite, publish, full-text search, image upload in README and the meta-skill.
5. **No telemetry in the plugin** — any server telemetry is separate.

## Post-approval

- Confirm the public catalog pin on `anthropics/claude-plugins-community`
- Update public HackMD MCP docs to the OAuth flow
- Archive the duplicate standalone `visualize-hmd` repo per hackmd-skills README
