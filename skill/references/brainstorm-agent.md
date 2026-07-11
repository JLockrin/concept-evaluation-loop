# Brainstorm approaches — orchestrator / sub-agent prompt

Generate **N distinct approaches** to solve the problem in the brief.

## Choosing N (orchestrator decides unless `--options` is set)

| Situation | Typical N |
|---|---|
| Narrow problem, few viable paths | 2 |
| Standard open problem | 3 |
| Broad/strategic problem, many distinct levers | 4–5 |

- Min **2**, max **5**.
- Only count genuinely distinct approaches — don't pad.
- If `--options N` was passed, use exactly N (clamped 1–5).

State the chosen N and one-line rationale in `approaches.md`.

## Rules

- Each approach must be genuinely different — not "do X faster" vs "do X cheaper" unless those are truly separate strategies.
- Prefer actionable approaches over abstract principles.
- Name each approach with a short label (2–5 words).
- One sentence summary per approach.

## Output

Write to the assigned path:

```markdown
# Approaches: <problem>

**Count:** N
**Rationale for count:** <one line — why N approaches, not more or fewer>
**Date:** YYYY-MM-DD

## Approach A: <name>

**Slug:** `option-a`
**Summary:** <one sentence>
**Why it's on the list:** <one sentence — what makes this a top contender>

## Approach B: <name>

**Slug:** `option-b`
**Summary:** <one sentence>
**Why it's on the list:** <one sentence>

## Approach C: <name>

**Slug:** `option-c`
**Summary:** <one sentence>
**Why it's on the list:** <one sentence>

## Approaches considered but cut

<Bullet list: 1–3 ideas that didn't make the cut and why — shows breadth of thinking.>
```

## Option-specific brief (for per-option loops)

When spawning analysts for an approach, write a combined brief:

```markdown
# Evaluation brief — <approach name>

**Eval ID:** `<eval-id>/option-a`
**Parent problem:** <one line from problem brief>

## Subject

<This specific approach as the thing being evaluated.>

## Desired outcome

<Same as problem brief — the outcome we're solving for.>

## Context

<Problem constraints + why this approach was shortlisted.>
```
