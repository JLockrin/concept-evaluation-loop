#!/usr/bin/env bash
set -euo pipefail

GIT="/c/Program Files/Git/bin/git.exe"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OWNER="JLockrin"
REPO_NAME="concept-evaluation-loop"

TOKEN="$("$GIT" credential fill <<EOF | awk -F= '/^password=/{print $2}'
protocol=https
host=github.com

EOF
)"

if [[ -z "$TOKEN" ]]; then
  echo "No GitHub credentials found in Git Credential Manager." >&2
  exit 1
fi

export GIT_AUTHOR_NAME="$OWNER"
export GIT_AUTHOR_EMAIL="${OWNER}@users.noreply.github.com"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"

cd "$REPO_ROOT"

if ! "$GIT" rev-parse HEAD >/dev/null 2>&1; then
  "$GIT" commit -m "Initial release of concept-evaluation-loop as a standalone shareable package." \
    -m "Extracts the multi-agent pro/against/lateral evaluation skill with install script, templates, and a sample evaluation."
fi

if ! curl -fsS -H "Authorization: token ${TOKEN}" "https://api.github.com/repos/${OWNER}/${REPO_NAME}" >/dev/null 2>&1; then
  curl -fsS -X POST \
    -H "Authorization: token ${TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/user/repos" \
    -d "{\"name\":\"${REPO_NAME}\",\"description\":\"Multi-agent pro/against/lateral evaluation loop for Cursor and agent harnesses\",\"private\":false}" \
    >/dev/null
  echo "Created GitHub repository ${OWNER}/${REPO_NAME}"
else
  echo "Repository ${OWNER}/${REPO_NAME} already exists"
fi

if ! "$GIT" remote get-url origin >/dev/null 2>&1; then
  "$GIT" remote add origin "https://github.com/${OWNER}/${REPO_NAME}.git"
fi

"$GIT" branch -M main
"$GIT" push -u origin main

echo "Published: https://github.com/${OWNER}/${REPO_NAME}"
