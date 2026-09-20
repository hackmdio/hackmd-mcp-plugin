#!/usr/bin/env bash
# PostToolUse: record baseline marker after get-note / get-team-note.
set -euo pipefail

INPUT="$(cat)"

NOTE_ID="$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    ti = d.get('tool_input') or d.get('toolInput') or {}
    for k in ('noteId', 'note_id', 'id'):
        v = ti.get(k)
        if v:
            print(v)
            break
except Exception:
    pass
" 2>/dev/null || true)"

[[ -n "$NOTE_ID" ]] || exit 0

if [[ -n "${PLUGIN_DATA:-}" ]]; then
  MARKER_ROOT="$PLUGIN_DATA"
elif [[ -n "${CLAUDE_PLUGIN_DATA:-}" ]]; then
  MARKER_ROOT="$CLAUDE_PLUGIN_DATA"
else
  MARKER_ROOT="${CLAUDE_PLUGIN_ROOT:?}"
fi
MARKER_DIR="${MARKER_ROOT}/.hackmd-baseline-markers"
mkdir -p "$MARKER_DIR"
date -u +%Y-%m-%dT%H:%M:%SZ >"${MARKER_DIR}/baseline-${NOTE_ID}"
exit 0
