---
name: concept-evaluation-loop
description: >
  Multi-agent evaluation for ideas and problems: auto-detects concept vs problem
  mode, runs parallel pro/con/lateral analysts, synthesizes a recommendation.
  Use when evaluating a decision, stress-testing an idea, or solving a problem —
  or when the user runs /concept-evaluation-loop.
user_invocable: true
---

# concept-evaluation-loop — orchestrator

**Slash command:** `/concept-evaluation-loop` or `/concept-evaluation-loop <brief>`

One slash command, two modes — **auto-detected** from the input.

| Mode | Trigger examples | What happens |
|---|---|---|
| **Concept** | "Should we…", "Is X a good idea", "Evaluate adding…" | One pro/con/lateral loop → synthesis |
| **Problem** | "How do we…", "What's the best way to…", "Solve…" | Brainstorm N approaches → loop each → meta-synthesis |

**N is chosen by the orchestrator** (2–5). Max **5**. Override with `--options N` only when you want to force a count.

You are the **orchestrator**. Do not argue the case yourself until synthesis.

## Output path

Resolve the evaluations root **once** at the start of each run:

1. If `.codex-harness/evaluations/` exists → use `.codex-harness/evaluations/<eval-id>/`
2. Else if `evaluations/` exists → use `evaluations/<eval-id>/`
3. Else → create `evaluations/<eval-id>/` (and copy `evaluations/README.md` from this skill's package if missing)

All paths below are relative to that root.

## Parse the invocation

| Input | Behavior |
|---|---|
| `/concept-evaluation-loop` | Ask what to evaluate or solve |
| `/concept-evaluation-loop <brief>` | Auto-detect mode from brief |
| `/concept-evaluation-loop <brief> --options 4` | Problem mode, 4 approaches (clamped 1–5) |
| `/concept-evaluation-loop <brief> outcome: <goal>` | Explicit desired outcome |

Optional flags: `--options N` (force N, clamped 1–5; omit to let orchestrator decide), `--concept`, `--problem`.

## 0. Detect mode

**Concept mode** — specific idea, decision, or proposal.
**Problem mode** — open question seeking approaches.

**If ambiguous**, ask one line: *"Evaluating one idea, or brainstorming approaches to a problem? (default: problem)"*

State detected mode and chosen approach count in chat before proceeding.

## Roles

| Role | Responsibility | Input |
|---|---|---|
| **Pro analyst** | Strongest arguments **for** | Brief only |
| **Con analyst** | Strongest arguments **against** | Brief only — **never** pro output |
| **Lateral analyst** | Alternative paths to outcome | Brief only — **never** pro/con output |
| **Orchestrator (you)** | Synthesize; in problem mode, brainstorm + meta-synthesize | All artifacts |

---

## Concept mode (single loop)

### 1. Capture brief → `<eval-root>/<eval-id>/brief.md`
Use [references/brief-template.md](references/brief-template.md).

Eval ID: `<subject-slug>-YYYY-MM-DD` — kebab-case from subject. Append `-2`, `-3` on collision.

### 2. Spawn analysts (parallel)
Launch all three in **one message**. Read-only (`readonly: true`). Isolation: brief only, no cross-reading.

| Agent | Prompt | Output |
|---|---|---|
| Pro | [references/pro-agent.md](references/pro-agent.md) | `pro.md` |
| Con | [references/con-agent.md](references/con-agent.md) | `against.md` |
| Lateral | [references/lateral-agent.md](references/lateral-agent.md) | `lateral.md` |

### 3. Synthesize
[references/synthesis-template.md](references/synthesis-template.md) → `synthesis.md`. Concise chat + links.

---

## Problem mode (brainstorm → loop each → meta-synthesize)

### 1. Capture problem brief
[references/problem-brief-template.md](references/problem-brief-template.md) → `brief.md`

State detected mode and chosen approach count in chat before proceeding.

### 2. Brainstorm N approaches (orchestrator chooses 2–5, or `--options` forces N)
[references/brainstorm-agent.md](references/brainstorm-agent.md) → `approaches.md`

### 3. Full concept loop per approach
Each in `option-a/`, `option-b/`, etc. with own brief + pro/against/lateral/synthesis.
Launch analysts for **all options** in as few parallel batches as possible (e.g. 3 options → 9 Task calls in one message).

### 4. Meta-synthesize
[references/meta-synthesis-template.md](references/meta-synthesis-template.md) → `meta-synthesis.md`

**Chat delivery:** Lead with winning approach. Link to approaches, each option synthesis, and meta-synthesis.

---

## Record (optional)

If the project has `brain/domains/concept-evaluation/README.md`:

- Append to Timeline in that file
- Append to `brain/LOG.md` if present

Skip when no `brain/` exists.

## Hard gates

- Pro/con parallel, isolated. Lateral isolated from both.
- Problem mode: orchestrator chooses N (2–5) unless `--options` set; max 5.
- Each approach gets full loop before meta-synthesis.
- Synthesis must cite **specific points** from analysts, not generic summaries.
- Chat: recommendation + links to artifacts.

## Examples

```
/concept-evaluation-loop Should we add a subscription tier?
/concept-evaluation-loop How do we reduce churn for repeat buyers?
/concept-evaluation-loop How do we improve onboarding? --options 4
```
