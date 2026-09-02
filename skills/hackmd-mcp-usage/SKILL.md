---
name: hackmd-mcp-usage
description: |
  Cross-tool policy for HackMD MCP tools (https://mcp.hackmd.io/, OAuth — no API
  token). Diff-before-patch when calling update-note or update-team-note
  (hook-enforced baseline). Structure-first when organizing notes into folders or
  books. Search honesty when locating notes (search-notes is title-only).
  Audience discipline and capability-gap disclosure when sharing or when MCP
  lacks the needed action. Metadata discipline when creating or retitling notes.
user-invocable: false
---

# HackMD MCP Usage Policy

Server `initialize` instructions cover per-tool semantics. This skill covers
**cross-tool policy**: rules that span multiple calls. Auth is OAuth through the
MCP host; the plugin needs no API token.

## Diff-before-patch — before every `update-*`

A PreToolUse hook **denies** `update-note` / `update-team-note` unless a `get-*`
call in this session wrote a baseline marker for the same `noteId` (marker is
written by the PostToolUse hook on `get-note` / `get-team-note`).

1. **Fetch baseline.** Call `get-note` (or `get-team-note`) for the target
   `noteId`. Done when the current body is in context — the marker now exists.
2. **Merge locally.** Apply the requested changes against that baseline. Done
   when every remote passage you did not intend to change is preserved verbatim.
3. **Write merged body.** Call `update-*` with the full merged content. Done
   when the update succeeds. If the hook denies, return to step 1.
4. **Co-editing races.** If a human may be editing concurrently, re-fetch
   immediately before step 3 and re-merge (see
   `reference/workflow-branches.md`).

Send the merged body derived from the fresh fetch — a body reconstructed from
memory or an earlier turn overwrites remote edits.

## Structure-first — organizing notes

Choose folder vs book by user intent before creating anything; read
`hackmd://guides/book` via `resources/read` before authoring a book note.
Decision table, namespace rules (team vs personal), and co-editing guidance:
`reference/workflow-branches.md`.

## Search honesty — locating notes

`search-notes` matches **titles only**. Escalate in order: title search →
list/filter by metadata → selective `get-note` on candidates → local match.
Fetch only the notes the task needs. If the user expects full-text search,
disclose the limit and file a gap report (`reference/capability-gaps.md`).

## Audience discipline — sharing

Identify the recipient first (workspace member / external / public) and hand
over the matching link type. MCP creates neither invite links nor published
pages: tell the user, guide them through the HackMD UI, and call `feedback`
with the matching template from `reference/capability-gaps.md`.

## Metadata discipline — creating and retitling

Set `title` and `description` through tool parameters; `content` carries the
Markdown body only. Parameter details: `reference/parameters.md`.

## Trash semantics

`delete-*` moves notes to trash, recoverable from the HackMD UI. Read a note
before any high-risk write so recovery has a reference point.

## Sibling skills

`push-to-hackmd` and `visualize-hmd` publish through the same MCP tools. This
policy and the diff-before-patch hooks apply to their writes as well.
