#!/usr/bin/env bash
# PostToolUse: record baseline marker after get-note / get-team-note.
set -euo pipefail

INPUT="$(cat)"

NOTE_ID="$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input') or {}
    for k in ('noteId', 'note_id', 'id'):
        v = ti.get(k)
        if v:
            print(v)
            break
except Exception:
    pass
" 2>/dev/null || true)"

[[ -n "$NOTE_ID" ]] || exit 0

MARKER_DIR="${CLAUDE_PLUGIN_ROOT:?}/.hackmd-baseline-markers"
mkdir -p "$MARKER_DIR"
date -u +%Y-%m-%dT%H:%M:%SZ >"${MARKER_DIR}/baseline-${NOTE_ID}"
exit 0
