# Workflow branches

## Structure-first: folder vs book

| User intent | Use |
| --- | --- |
| Related docs, order does not matter | **Folder** — `list-folders`, `create-folder`, `add-note-to-folder` |
| Reading order matters (A before B) | **Folder** for the notes + a **book note** as the ordered guide |
| Cross-folder / cross-workspace index | **Book note** with ordered links |

A book is Markdown structure inside a note. Read `hackmd://guides/book` via
`resources/read` before authoring one — it defines the link format the Book
viewer expects. Neo vs Classic viewer is a UI setting; author the Markdown
structure and let the user pick the viewer.

`add-note-to-folder` **moves** the note: a note lives in exactly one folder.
Confirm with the user before moving a note that already has a home.

## Namespace: team vs personal

| Situation | Namespace |
| --- | --- |
| Team collaboration, shared workspace content | Team notes — `create-team-note`, `update-team-note`, pass `teamPath` |
| Personal drafts, scratch work | Personal notes — omit `teamPath` |

Match the namespace to where collaborators will look for the note, not to
which tool is more convenient. When in doubt about a shared deliverable,
prefer the team namespace and confirm the `teamPath` with the user.

## Co-editing

HackMD notes are live-collaborative. When a human may be editing the same
note:

1. Re-fetch with `get-note` immediately before the `update-*` call, so the
   baseline is seconds old, not minutes.
2. If the server warns of a contested edit, re-fetch, re-merge, and retry
   once. If content keeps shifting, hand the merge decision to the user
   instead of overwriting.
