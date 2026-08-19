#!/bin/sh
set -eu
STATE_FILE="docs/architecture/.architecture-state.json"

if [ ! -f "$STATE_FILE" ]; then
  echo "ARCHITECTURE_STATE=UNKNOWN"
  echo "reason=state_file_missing"
  exit 0
fi

BASE=$(python3 -c 'import json; print(json.load(open("docs/architecture/.architecture-state.json")).get("last_sync_commit") or "")')
HEAD=$(git rev-parse HEAD 2>/dev/null || true)

echo "BASE_COMMIT=$BASE"
echo "HEAD_COMMIT=$HEAD"

if [ -n "$BASE" ] && git cat-file -e "$BASE^{commit}" 2>/dev/null; then
  echo "COMMITS_CHANGED:"
  git diff --name-only "$BASE..HEAD" || true
else
  echo "COMMITS_CHANGED=UNKNOWN"
fi

echo "UNCOMMITTED:"
git diff --name-only || true

echo "STAGED:"
git diff --cached --name-only || true
