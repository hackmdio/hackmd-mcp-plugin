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

Turn conversation context into a designed HTML/CSS note on HackMD through **MCP OAuth**. Follow `hackmd-mcp-usage` and hooks on every write.

**Scope:** a **generated** visualization from the discussion — a single shareable page for an audience (not a prose summary in chat). An existing file to upload goes through `push-to-hackmd`.

**Scripts:** `SKILL_DIR="${CLAUDE_PLUGIN_ROOT}/skills/visualize-hmd"`

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

### 3. Write standalone HTML

Write `/tmp/viz.html` with `<!DOCTYPE html>`, `<html>`, `<head>` (Google Fonts `<link>`), `<body>`. CSS Grid/Flexbox only, no JavaScript, `<div>` for containers. Done when it previews in a browser.

### 4. Build — HackMD-safe markup

```bash
python3 "$SKILL_DIR/scripts/to-hackmd.py" --strict /tmp/viz.html /tmp/viz-hackmd.html
```

Done when exit code is 0. On failure fix HTML (blank lines, `<main>`, unscoped `body{}`) and rebuild. Do not publish until build passes.

### 5. Verify MCP

Call a lightweight MCP tool to confirm OAuth connection. Unavailable → stop; ask the user to enable the HackMD plugin.

### 6. Publish via MCP

**Create (default):** `create-note` with `title` (e.g. `Visualization — <topic>`), optional `description`, and `content` from `/tmp/viz-hackmd.html`.

**Update:** when the user gives a note URL or id — `get-note` (baseline marker) → replace body with built HTML → `update-note` with full merged content per `hackmd-mcp-usage`. Hook deny → re-fetch and retry.

Prepend to the note body:

```html
<!-- Enable Custom CSS preview: paintbrush → Custom CSS -->
```

Done when MCP returns a note id. Report failures verbatim; never claim success without an id.

### 7. Custom CSS reminder

Tell the user to enable **Custom CSS** in the HackMD toolbar. Built output > 500 KB → warn; suggest `<details>` or splitting notes.

## Failure modes

| Failure | Recovery |
|---------|----------|
| `to-hackmd.py --strict` fails | Fix HTML; rebuild (step 4) |
| MCP publish fails | Report the error; do not claim success |
| Unstyled note | Custom CSS preview not enabled — repeat step 7 |

## Antipatterns

- Decorative sections that repeat card content
- More than 3 accent colors
- Omitting the crux when a hard trade-off exists
- JavaScript (stripped by HackMD)

## Related skills

- `push-to-hackmd` — user already has a file to upload
- `hackmd-mcp-usage` — MCP policy and hooks
- [reference.md](reference.md) — design tokens and layout patterns
