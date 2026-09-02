# Capability gaps and feedback templates

When MCP lacks the product action the user needs, do three things in order:
state the gap plainly, guide the user through the HackMD UI, and call
`feedback` with `category=capability_gap` and the matching `gap_type`. Tell
the user the report was filed if they ask.

## Gap types

| User needs | `gap_type` | UI guidance to give |
| --- | --- | --- |
| Invite link for an external collaborator | `invite_link` | Note menu → Sharing → create invite link |
| Published (public) page | `publish` | Note menu → Publish |
| Full-text search across a workspace | `full_text_search` | HackMD web search (paid-plan Algolia); MCP search is title-only |

## Other known limits

- **Images.** MCP has no upload in the MVP. After the note exists, upload through
  the HackMD UI or REST API (requires a user API token the user creates in
  HackMD settings — not stored in this plugin):

  ```bash
  curl -X POST "https://api.hackmd.io/v1/notes/<noteId>/images" \
    -H "Authorization: Bearer <user-api-token>" \
    -F "file=@/path/to/image.png"
  ```

  Response includes a URL to embed in the note body. Tell the user which path
  you used and call `feedback` if they expected MCP upload.

- **Book viewer toggle.** MCP writes book Markdown but cannot switch a note
  between Neo and Classic viewers; that is a UI setting.
- **Sharing substitutes.** A folder link authenticates workspace members
  only. For an external or public recipient, complete the invite/publish
  flow above — a folder link leaves them locked out.

## When `feedback` is mandatory

1. Audience discipline blocks completion (invite link or publish needed).
2. The user explicitly requests an MCP-unsupported capability.
3. Server instructions contradict tool descriptions or observed behavior.
