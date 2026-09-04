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

Use the English wording. Success is observable without talking to us.

1. List the HackMD notes I opened recently (note history is enough). Pick at most 3, read each with get-note, and write a two-sentence summary. Do not create or edit any note.
2. Create a new HackMD note titled "Verona 5-day itinerary". Body: a Markdown plan for five days in Verona, Italy, with morning / afternoon / evening for each day. Do not add HTML or CSS. When done, reply with only the title and the note URL.
3. Create a single-page HTML/CSS visualization (no JavaScript) that compares two ways to share a trip on HackMD: a Markdown itinerary versus a one-page visual overview. Upload it as a new HackMD note, return the note URL, and remind me to enable Custom CSS preview.

Verified 2026-09-02 against `https://mcp.hackmd.io/` as `elek@hackmd.io`: `get-me`, `get-history`, `get-note`, and two `create-note` calls succeeded. MCP `list-notes` / `get-note` do not expose a last-updated filter, and `search-notes` is title-only — do not ask reviewers to “summarize edits from the last 7 days”.

## Reviewer test account

Anthropic asks for a **standard testing account with sample data** so a reviewer can run the plugin without emailing us. Credentials go **only** in the submission form (Test & launch / test-account fields), never in git.

### What to create

1. A dedicated HackMD user (not a staff daily-driver). Email + password is easier for reviewers than SSO-only.
2. Grant it a free or paid plan that can create notes (prompts 2 and 3 write new notes).
3. Seed data **before** you submit, so prompt 1 is not an empty history:

| Seed | Why |
| --- | --- |
| ≥3 notes with real paragraphs (not empty Untitled) | Prompt 1 (`get-history` + `get-note`) |
| Open those three notes in the HackMD UI once | They appear in note history |
| Distinct titles | Easy for the reviewer to match summaries |
| Write quota that allows two new notes | Prompts 2 and 3 call `create-note` |

Suggested seed titles (open each once the day you submit):

- `Review seed — project log`
- `Review seed — meeting notes`
- `Review seed — travel research`

### What to paste into the Anthropic form

- Login URL: `https://hackmd.io/login`
- Email and password of the test user
- One sentence: “OAuth to `https://mcp.hackmd.io/` as this user. Open the `Review seed — *` notes once so they appear in history. Prompts 2 and 3 create new notes.”
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
