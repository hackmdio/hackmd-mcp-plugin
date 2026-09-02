# Parameter reference

| Parameter | Guidance |
| --- | --- |
| `noteId` | UUID or short ID; both resolve the same way `get-note` does. The diff-before-patch hook keys its baseline marker on this value — use the same form in `get-*` and `update-*`. |
| `teamPath` | Required for team-scoped notes and folders; omit for the personal workspace. |
| `folderId` | Obtain from `create-folder` or `list-folders`. `add-note-to-folder` moves the note — one folder per note. |
| `title` | Note title, set as a parameter. Skip adding an H1 to the body solely to name the note. |
| `description` | Note summary metadata, set as a parameter. Keep it out of the body and out of YAML frontmatter. |
| `content` | Markdown body only. On `update-*`, send the full merged body from the fresh baseline. |
