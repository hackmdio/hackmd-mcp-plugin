# OpenAI Plugins Directory — listing draft

Paste these fields into the OpenAI plugin portal (**With MCP**). Do not put passwords or session cookies in this file. Demo credentials live only in Linear (DEV-3147 / P-1048) and the portal's private test-account fields.

Package: this repo, v1.2.0. Manifest: `.codex-plugin/plugin.json`. MCP URL: `https://mcp.hackmd.io/` (enter in the portal; do not upload as Skills-only — a ZIP that includes `.mcp.json` is rejected on that path).

## Listing

| Portal field | Value | Limit |
| --- | --- | --- |
| Display name | HackMD | 30 |
| Short description | Collaborative Markdown notes | 30 (28 used) |
| Developer name | HackMD | 80 |
| Category | Productivity | enum |
| Website | https://hackmd.io | HTTPS |
| Privacy | https://hackmd.io/s/privacy | HTTPS |
| Terms | https://hackmd.io/s/terms | HTTPS |
| Support | https://hackmd.io/s/tutorials | HTTPS (not mailto) |
| Logo | Upload the production HackMD mark in the portal. This repo does not ship a raster logo. | portal |

### Long description

```
HackMD is a collaborative Markdown workspace. This plugin connects ChatGPT and Codex to your HackMD account through OAuth at https://mcp.hackmd.io/ — the plugin does not store an API token.

You can list recent notes from history, read and create Markdown notes (including team notes when you name a team), update a note only after fetching it first, organize notes into folders and books, and turn a discussion into a single-page HTML/CSS visualization published as a HackMD note.

Ordinary ChatGPT Chat does not run plugin hooks. Before every update, call get-note or get-team-note and send the full merged body. Codex and ChatGPT Work can enforce the same rule with bundled hooks after you trust them.

MCP cannot create invite links, publish a public page, search note bodies (search is title-only), or upload images. Use the HackMD web UI for those actions. Requires a HackMD account.
```

### Capabilities

- Create and edit Markdown notes
- Organize notes into folders and books
- Read recent note history
- Publish HTML/CSS visualizations as notes

### Starter prompts (exactly these three; one line, ≤128 chars)

1. `List my recent HackMD notes, read up to 3 with get-note, and summarize each in two sentences. Do not create or edit notes.` (122)
2. `Create a HackMD note titled Verona 5-day itinerary: Markdown plan, 5 days, morning/afternoon/evening. Reply with title and URL.` (127)
3. `Create a one-page HTML/CSS (no JS) comparing Markdown vs visual trip overviews; upload as a HackMD note and return the URL.` (123)

## Developer Mode 實測紀錄（2026-09-20）

Live ChatGPT OAuth still depends on DEV-3148 (challenge token + ChatGPT redirect). This session recorded what can be checked without that org session.

| Check | Result |
| --- | --- |
| `POST https://mcp.hackmd.io/` without token | HTTP 401 JSON-RPC; `WWW-Authenticate` Bearer + `resource_metadata=https://mcp.hackmd.io/.well-known/oauth-protected-resource` |
| Protected resource metadata | `{"resource":"https://mcp.hackmd.io","authorization_servers":["https://hackmd.io"],"scopes_supported":["mcp"]}` |
| ChatGPT in a clean browser | Login wall (`chatgpt.com` → Log in / Sign up). No HackMD company OpenAI org session in this environment, so Developer Mode → add MCP → OAuth could not be exercised. |
| Cursor preview browser | No automation host — could not drive ChatGPT from the IDE preview. |
| Test account seed | Logged in at `https://hackmd.io/login` as `mcp@hackmd.io` (no MFA). User `hackmd-mcp-test` is Admin of `hackmd-mcp-test-team`. History has the three Review seed notes; bodies are real paragraphs; each note was opened. |

## Developer Mode 實測紀錄（2026-09-27）

Logged-in ChatGPT in Arc’s HackMD profile. Visible account: **Max Wu**, plan **免費版**. Developer mode was off; this session turned **開發者模式** on (安全性與登入). Plugins → 新增外掛程式 → 建立應用程式 → 建立 MCP 應用程式, name `HackMD`, URL `https://mcp.hackmd.io/`, auth OAuth, risk checkbox on, then 建立.

ChatGPT left for HackMD authorize. The page body was only:

```json
{"error":"invalid_request","error_description":"Unsupported MCP OAuth client_id."}
```

Observed authorize request (query shape, not a full paste of `state` / `code_challenge`):

| Param | Value |
| --- | --- |
| Endpoint | `https://hackmd.io/mcp/oauth/authorize` |
| `response_type` | `code` |
| `client_id` | `https://chatgpt.com/oauth/A15BxIyxUtob/client.json` |
| `redirect_uri` | `https://chatgpt.com/connector/oauth/A15BxIyxUtob` |
| `scope` | `mcp` |
| `code_challenge_method` | `S256` |
| `resource` | `https://mcp.hackmd.io` |
| `ui_locales` | `zh-TW` |

HackMD rejected the client before any consent screen. `client_id` is a ChatGPT CIMD document URL, not a pre-registered client id. `scope` is only `mcp`. No tool call ran, so the three starters were not observed.

**Flag for Dev (DEV-3148):** accept this ChatGPT CIMD `client_id` and `redirect_uri` on `https://hackmd.io/mcp/oauth/authorize`. Advertised scope is still only `mcp`; workspace-domain guidance also wants `openid` + `email` and UserInfo `email_verified: true`.

## Reviewer fixtures

Paste into the portal's demo-credentials fields only:

- Login URL: `https://hackmd.io/login`
- Email: `mcp@hackmd.io` (password in Linear, not git)
- Team path: `hackmd-mcp-test-team`
- No MFA / email / SMS
- Seed notes (open each once so they appear in history):

| Title | URL |
| --- | --- |
| Review seed — project log | https://hackmd.io/Hh7FRWCPQrqxtDJnNIZvMQ |
| Review seed — meeting notes | https://hackmd.io/TlkIRFXXTMGgroZVRCtMnQ |
| Review seed — travel research | https://hackmd.io/mgXvPvs7QauYnx7jTjVoLQ |

Verified 2026-09-20 as `mcp@hackmd.io`: all three have real paragraphs, `isVisited: true`, and the user is Admin of team `hackmd-mcp-test-team`. History has exactly these three notes. The account still shows a “complete your account setup” Gist banner (Later / Finish setup) — it does not block note access; dismiss Later if it covers the overview.

OAuth to `https://mcp.hackmd.io/` as this user. Starters 2 and 3 and positive cases 2–5 create or update notes.

## Positive test cases (5)

Reviewers can run these without talking to us. Success is a note URL, a short summary list, or an explicit refusal with UI guidance.

### P1 — Read history (read-only)

- **Prompt:** Starter 1.
- **Expected tools:** `get-history`, then `get-note` up to three times. No `create-*` / `update-*` / `delete-*`.
- **Expected result:** Two-sentence summaries for up to three notes. Titles should match the Review seed notes if history is the seed set.
- **Fixture:** Seed notes opened at least once.

### P2 — Create Markdown note

- **Prompt:** Starter 2.
- **Expected tools:** `create-note` (or `create-team-note` if the model targets the test team) with Markdown, not HTML/CSS.
- **Expected result:** Reply contains only (or clearly) the title `Verona 5-day itinerary` and a `https://hackmd.io/…` URL. Opening the URL shows a five-day plan with morning / afternoon / evening.
- **Fixture:** Write quota on the test account.

### P3 — Visualize as HTML note

- **Prompt:** Starter 3.
- **Expected tools:** `create-note` with HTML/CSS body (no JavaScript). May precede with a lightweight read tool to confirm OAuth.
- **Expected result:** A note URL. Opening it shows a one-page comparison. Model reminds the user to enable Custom CSS preview (paintbrush). Must succeed **without** local `python3` or `/tmp`.
- **Fixture:** Same as P2.

### P4 — Read a named seed note

- **Prompt:** `Open the HackMD note titled "Review seed — meeting notes", quote one sentence from the body, and do not edit it.`
- **Expected tools:** `search-notes` and/or `get-history`, then `get-note`. No writes.
- **Expected result:** A quoted sentence that exists in that seed note.
- **Fixture:** Seed note `Review seed — meeting notes` with real paragraphs.

### P5 — Update after fetch

- **Prompt:** `Update the HackMD note titled "Review seed — project log": fetch it first, append a Markdown checkbox item "- [ ] Reviewer ping" at the end, keep the rest of the body unchanged, and return the note URL.`
- **Expected tools:** `get-note` (or `get-team-note`) **before** `update-note` (or `update-team-note`). On ChatGPT Chat, hooks will not fire; the fetch must still happen. On Codex, a missing fetch should deny and the model should retry after `get-note`.
- **Expected result:** URL loads with the original seed paragraphs plus the new checkbox. Earlier text is not replaced by a stub.
- **Fixture:** Seed note `Review seed — project log`.

## Negative test cases (3)

### N1 — Public publish is not an MCP tool

- **Prompt:** `Publish the note "Review seed — travel research" to a public HackMD page using the plugin. Do not send me to the website.`
- **Expected:** Refuse to call a non-existent publish tool. State that MCP cannot publish. Guide: note menu → Publish. Call `feedback` with `gap_type=publish` if that tool exists. Do not claim the note is public.
- **Why not complete:** Capability gap (`publish`).

### N2 — Invite link is not an MCP tool

- **Prompt:** `Invite coworker@example.com to edit Review seed — meeting notes by creating an invite link in the plugin.`
- **Expected:** Refuse. Guide: note menu → Sharing → create invite link. `feedback` with `gap_type=invite_link` if available. Do not invent a share URL.
- **Why not complete:** Capability gap (`invite_link`).

### N3 — Search is title-only

- **Prompt:** `Search the full text of all my HackMD notes for the word "budget" and list every paragraph that contains it.`
- **Expected:** Disclose that `search-notes` matches titles only. Do not pretend to have scanned bodies of the whole workspace. May title-search, then optionally `get-note` on a few candidates, and say the rest needs HackMD web search. `feedback` with `gap_type=full_text_search` if the user insisted on full-text MCP search.
- **Why not complete:** Capability gap (`full_text_search`).

## Demo recording script

Record in ChatGPT (Developer Mode or the submitted plugin) signed in to the HackMD company OpenAI org, then OAuth as `mcp@hackmd.io`. One take can cover ChatGPT Chat; mention Codex hooks in a caption if you do not record Codex.

1. **Connect.** Show Plugins / Developer Mode → MCP `https://mcp.hackmd.io/` → HackMD OAuth consent → return to chat.
2. **P1.** Paste starter 1. Show three summaries. Scroll enough to see that no create/update tools ran.
3. **P2.** Paste starter 2. Click the returned URL (or show it) so the five-day Markdown plan is visible.
4. **P3.** Paste starter 3. Show the visualization note URL and the Custom CSS reminder.
5. **N1.** Paste the publish prompt. Show the refusal and the Publish UI guidance.

Keep secrets off screen: do not show the test password. 15–90 seconds per step is enough.

## Release notes (portal)

Initial OpenAI Plugins Directory submission (With MCP). Same OAuth MCP as the Claude Code marketplace plugin (`https://mcp.hackmd.io/`). Skills: `hackmd-mcp-usage`, `push-to-hackmd`, `visualize-hmd`. Visualization no longer requires local `python3` or `/tmp`. Hooks emit Codex `hookSpecificOutput` deny JSON; ChatGPT Chat still must `get-note` before every update because Chat does not run hooks.

## Packaging for Dev (DEV-3148)

1. Submission type: **With MCP** (not Skills-only).
2. MCP server URL (Universal): `https://mcp.hackmd.io/`
3. Attach this repository as the skill bundle (`.codex-plugin/plugin.json` + `skills/` + `hooks/`).
4. If the portal rejects `.mcp.json` on a ZIP upload, omit `.mcp.json` from the archive — the MCP URL is already in the form.
5. Domain verification, ChatGPT OAuth redirect, Scan Tools, and annotation justifications stay on DEV-3148.
6. After scan, confirm every tool has `readOnlyHint`, `openWorldHint`, `destructiveHint` plus a justification.

## Hook output check

```bash
printf '%s' '{"tool_input":{}}' | hooks/scripts/guard-update-note.sh
```

Stdout must be a single JSON object:

```json
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"…"}}
```
