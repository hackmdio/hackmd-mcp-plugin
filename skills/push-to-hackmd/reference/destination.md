# Destination decision tree

Policy: **ask-first when ambiguous**. Infer only when the user gave an explicit URL, note id, or an unambiguous phrase.

## URL and id parsing

| Input | Action |
| --- | --- |
| `https://hackmd.io/<noteId>` | Use `<noteId>` as the MCP note id |
| `https://hackmd.io/@<team>/<shortId>` | List team notes via MCP; match `shortId`; set `teamPath` |
| Bare id string | Use directly as `noteId` |

## Decision tree

```
User gave hackmd.io URL or note id?
  yes → parse per table above
User said "new" / "create" / no existing note implied?
  yes → create path (SKILL.md step 4a)
User said "update" / gave a title to match?
  yes → search-notes (title-only)
        • 0 matches → ask the user
        • 1 match     → use that noteId
        • 2+ matches  → list candidates; ask (never pick arbitrarily)
User named a team?
  yes → confirm team exists via MCP team listing; otherwise stop with an error
No team mentioned?
  → personal workspace
Folder requested?
  → list-folders / create-folder / add-note-to-folder (MCP folder tools)
```

Record `noteId`, `teamPath` (if any), and `folderId` when a folder is used.
