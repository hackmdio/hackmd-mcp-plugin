# Edge cases

- **Very large content**: split across notes or warn before sending very large bodies (> 5 MB confirm; > 50 MB stop per HackMD limits).
- **HTML with `<style>`**: rebuild through `visualize-hmd`'s `to-hackmd.py`; prepend `<!-- Enable Custom CSS preview (paintbrush → Custom CSS) -->`.
- **Images**: MCP has no image upload in MVP. After the note exists, use HackMD UI or REST API upload; see `hackmd-mcp-usage/reference/capability-gaps.md` and call `feedback` if the user expected MCP upload.
- **Binary assets**: notes carry text only; host files elsewhere and link, or upload images after create.
- **MCP unavailable**: stop; ask the user to enable the plugin and complete OAuth. Do not fall back to API tokens or CLI.
- **Hook deny on update**: call `get-note` again, re-merge, retry `update-note`.
- **Contested edit warning**: re-fetch, merge with user input if needed, then update.
