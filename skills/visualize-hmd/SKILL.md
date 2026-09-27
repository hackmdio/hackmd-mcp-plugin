---
name: visualize-hmd
description: >-
  Crux-first HTML/CSS visualization of the current discussion, published as a
  HackMD note via OAuth MCP. Use when the user asks to visualize or turn the
  discussion into a webpage, wants a single shareable page that explains the
  discussion to an audience, or asks to update an existing visualization note.
  Not for uploading existing files — route those to push-to-hackmd.
---

# Visualize — HackMD

Turn conversation context into a designed HTML/CSS note on HackMD through **MCP OAuth**. Follow `hackmd-mcp-usage` on every write.

**Scope:** a **generated** visualization from the discussion — a single shareable page for an audience (not a prose summary in chat). An existing file to upload goes through `push-to-hackmd`.

**Do not depend on `/tmp` or `python3`.** ChatGPT Chat has neither a reliable local filesystem nor plugin hooks. Emit HackMD-safe markup in context and pass it to MCP. The bundled `scripts/to-hackmd.py` is an optional Codex check, not the publish path.

## Steps

### 1. Crux — analyze context

Identify trade-offs, phases, decisions, or an overview. For an audience-facing page, frame the **crux** as what they must understand or decide. Done when the crux fits one sentence.

### 2. Select a layout

```
Exactly 2 competing options with clear pros/cons → Trade-off map
4–6 sequential phases with distinct boundaries  → Phase runway
3+ independent decisions, no natural order      → Decision grid
Otherwise / mixed / overview only               → Brief (hero + sections)
Multiple patterns apply                         → the one that makes the crux most visible
```

Use fragments and class names from [reference.md](reference.md) only.

### 3. Write HackMD-safe markup

Write the **note body** (not a full HTML document):

- `<style>…</style>` then a single wrapper (`viz-root` or `viz-shell`) around the page
- CSS Grid / Flexbox only; no JavaScript; `<div>` for containers — no `<main>`
- No `<html>`, `<head>`, `<body>`, or external CSS `<link>`
- No bare `html{}` or `body{}` rules (scope under `.viz-root` / `.viz-shell`)
- No blank lines inside the HTML body (HackMD Type 6 block termination)
- No 4-space-indented HTML lines (those become Markdown code blocks)
- Prepend to CSS: Google Fonts `@import` plus `.markdown-body { max-width: none !important; padding: 0 !important; }`

Boilerplate: [reference.md](reference.md). Done when the markup satisfies the constraints above.

Optional Codex-only check: if `python3` and a writable directory exist, wrap the page in `<html><body>` plus a `<style>` block, run `python3 "${SKILL_DIR:-.}/scripts/to-hackmd.py" --strict <in> <out>`, and use the converted body. Skip this on ChatGPT Chat.

### 4. Verify MCP

Call a lightweight MCP tool to confirm OAuth connection. Unavailable → stop; ask the user to enable the HackMD plugin.

### 5. Publish via MCP

**Create (default):** `create-note` with `title` (e.g. `Visualization — <topic>`), optional `description`, and `content` set to the HackMD-safe markup from step 3.

**Update:** when the user gives a note URL or id — `get-note` (baseline) → replace body with the new markup → `update-note` with full merged content per `hackmd-mcp-usage`. ChatGPT Chat does not run hooks; fetch anyway. If a Codex/Work hook denies, re-fetch and retry.

Prepend to the note body:

```html
<!-- Enable Custom CSS preview: paintbrush → Custom CSS -->
```

Done when MCP returns a note id. Report failures verbatim; never claim success without an id.

### 6. Custom CSS reminder

Tell the user to enable **Custom CSS** in the HackMD toolbar. Built output > 500 KB → warn; suggest `<details>` or splitting notes.

## Failure modes

| Failure | Recovery |
|---------|----------|
| Markup violates HackMD constraints | Fix in context; do not publish until constraints hold |
| MCP publish fails | Report the error; do not claim success |
| Unstyled note | Custom CSS preview not enabled — repeat step 6 |

## Antipatterns

- Decorative sections that repeat card content
- More than 3 accent colors
- Omitting the crux when a hard trade-off exists
- JavaScript (stripped by HackMD)
- Writing `/tmp/viz.html` or requiring `python3` on ChatGPT Chat

## Related skills

- `push-to-hackmd` — user already has a file to upload
- `hackmd-mcp-usage` — MCP policy
- [reference.md](reference.md) — design tokens and layout patterns
