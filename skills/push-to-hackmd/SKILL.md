---
name: push-to-hackmd
description: >-
  Publish to HackMD via OAuth MCP. Use when the user says "push to HackMD" or
  "publish to HackMD" (create a note), "save to HackMD" or "backup to HackMD"
  (upload content), or "update this HackMD note" (merge without clobbering).
  Route "visualize" or audience one-page requests to visualize-hmd.
---

# Push to HackMD

Create or update HackMD notes from local files or session output through **MCP OAuth** (`https://mcp.hackmd.io/`). Follow the sibling `hackmd-mcp-usage` policy and hooks on every write.

## Steps

### 1. Resolve content

Read the file the user named, or extract text from the session. Bodies may be plaintext, Markdown, HTML, or CSS. Combine multiple files under headings, or one note per file — confirm with the user. Title from the first `#` heading or filename stem; ask once if unclear.

Rich standalone HTML: defer to `visualize-hmd` and its `to-hackmd.py` build step.

Done when you have a title and body text ready to send.

### 2. Verify MCP

Call a lightweight MCP tool (e.g. list notes) to confirm the plugin connection. First use triggers browser OAuth. If MCP tools are unavailable, stop and ask the user to enable the HackMD plugin.

Done when MCP responds successfully.

### 3. Choose destination

Ask when ambiguous; infer only from an explicit URL, note id, or clear intent ("new note", "update this note"). Rules: [reference/destination.md](reference/destination.md).

Done when you have a target `noteId` (+ `teamPath` for team notes) or a confirmed create.

### 4a. Create

`create-note` or `create-team-note` with `title`, optional `description`, and `content`. Use folder MCP tools when the user wants a folder (`list-folders`, `create-folder`, `add-note-to-folder`).

Done when the tool returns a note id.

### 4b. Update (diff-before-patch)

Follow `hackmd-mcp-usage` exactly:

1. `get-note` / `get-team-note` for the target id (hook writes baseline marker).
2. Merge local changes into that baseline.
3. `update-note` / `update-team-note` with the full merged body.

If the PreToolUse hook denies, return to step 1. On contested-edit warnings, re-fetch and merge before retrying.

Done when update succeeds.

### 5. Report

Return the note URL (`https://hackmd.io/<noteId>`), workspace (personal or team), and whether the note was created or updated. For HTML notes, remind the user to enable **Custom CSS** preview (paintbrush → Custom CSS).

## Edge cases

[reference/edge-cases.md](reference/edge-cases.md)

## Related skills

- `visualize-hmd` — generated HTML visualization from the discussion
- `hackmd-mcp-usage` — MCP workflow policy and hooks
