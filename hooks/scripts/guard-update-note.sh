#!/usr/bin/env bash
# PreToolUse: deny update-* unless get-* wrote a baseline marker for noteId.
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

deny() {
  local reason="$1"
  python3 -c "import json,sys; print(json.dumps({'hookEventName':'PreToolUse','permissionDecision':'deny','permissionDecisionReason':sys.argv[1]}))" "$reason"
  exit 0
}

if [[ -z "$NOTE_ID" ]]; then
  deny "HackMD diff-before-patch: update-* requires noteId. Call get-note (or get-team-note) first, then update with merged content."
fi

MARKER_DIR="${CLAUDE_PLUGIN_ROOT:?}/.hackmd-baseline-markers"
MARKER="${MARKER_DIR}/baseline-${NOTE_ID}"

if [[ ! -f "$MARKER" ]]; then
  deny "HackMD diff-before-patch: no baseline for note ${NOTE_ID}. Call get-note (or get-team-note) for this noteId, merge your edits locally, then call update-*."
fi

# One update per baseline fetch — next update requires a fresh get-*.
rm -f "$MARKER"
exit 0
