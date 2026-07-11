#!/usr/bin/env bash
# Install concept-evaluation-loop into a project or globally.
#
# Usage:
#   bash scripts/install.sh                  # install into current directory
#   bash scripts/install.sh /path/to/project
#   bash scripts/install.sh --global         # install to ~/.cursor and ~/.agents

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GLOBAL=false
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global|-g)
      GLOBAL=true
      shift
      ;;
    --help|-h)
      echo "Usage: bash scripts/install.sh [--global] [target-project-dir]"
      exit 0
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

copy_skill() {
  local dest_agents="$1"
  local dest_cursor="$2"

  mkdir -p "$dest_agents" "$dest_cursor"
  rm -rf "$dest_agents/concept-evaluation-loop"
  cp -R "$REPO_ROOT/skill" "$dest_agents/concept-evaluation-loop"

  cat > "$dest_cursor/concept-evaluation-loop/SKILL.md" << 'CURSOR_STUB'
---
name: concept-evaluation-loop
description: >
  Evaluate an idea or solve a problem with parallel pro/con/lateral analysts.
  Auto-detects concept vs problem mode. Use when the user runs
  /concept-evaluation-loop or asks to evaluate, stress-test, or solve something.
user_invocable: true
---

# /concept-evaluation-loop

One command, two auto-detected modes:

| Mode | Input shape | Flow |
|---|---|---|
| **Concept** | "Should we…", "Is X worth it" | 1 loop → synthesis |
| **Problem** | "How do we…", "Best way to…" | Brainstorm N (orchestrator picks 2–5) → loop each → meta-synthesis |

## Parse the invocation

| Input | Behavior |
|---|---|
| `/concept-evaluation-loop` | Ask what to evaluate or solve |
| `/concept-evaluation-loop <brief>` | Auto-detect mode |
| `/concept-evaluation-loop <brief> --options 4` | Problem mode, 4 approaches |

Flags: `--options N` (force count; omit to let orchestrator decide), `--concept`, `--problem`.

## Execute

Read and follow **in full**: `.agents/skills/concept-evaluation-loop/SKILL.md`

## Examples

```
/concept-evaluation-loop Should we add a subscription tier?
/concept-evaluation-loop How do we reduce churn for repeat buyers?
/concept-evaluation-loop How do we improve onboarding? --options 4
```
CURSOR_STUB

  echo "  skill → $dest_agents/concept-evaluation-loop/"
  echo "  stub  → $dest_cursor/concept-evaluation-loop/SKILL.md"
}

install_evaluations_readme() {
  local project_root="$1"
  local eval_dest

  if [[ -d "$project_root/.codex-harness" ]]; then
    eval_dest="$project_root/.codex-harness/evaluations"
  else
    eval_dest="$project_root/evaluations"
  fi

  mkdir -p "$eval_dest"
  cp "$REPO_ROOT/evaluations/README.md" "$eval_dest/README.md"
  echo "  eval  → $eval_dest/README.md"
}

install_brain_template() {
  local project_root="$1"
  if [[ -d "$project_root/brain" && ! -f "$project_root/brain/domains/concept-evaluation/README.md" ]]; then
    mkdir -p "$project_root/brain/domains/concept-evaluation"
    cp "$REPO_ROOT/brain-template/domains/concept-evaluation/README.md" \
      "$project_root/brain/domains/concept-evaluation/README.md"
    echo "  brain → brain/domains/concept-evaluation/README.md"
  fi
}

if $GLOBAL; then
  HOME_DIR="${HOME:-$USERPROFILE}"
  echo "Installing globally to $HOME_DIR"
  copy_skill "$HOME_DIR/.agents/skills" "$HOME_DIR/.cursor/skills"
  echo "Done. Evaluations README is installed per-project when you run install without --global."
  exit 0
fi

PROJECT_ROOT="${TARGET:-$(pwd)}"
PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd)"

echo "Installing concept-evaluation-loop into: $PROJECT_ROOT"
copy_skill "$PROJECT_ROOT/.agents/skills" "$PROJECT_ROOT/.cursor/skills"
install_evaluations_readme "$PROJECT_ROOT"
install_brain_template "$PROJECT_ROOT"
echo "Done. Run /concept-evaluation-loop in Cursor to start."
