# Synthesis — orchestrator output template



Use this for `synthesis.md` and as the structure for the concise chat response.



```markdown

# Evaluation synthesis: <subject>



**Eval ID:** `<eval-id>`

**Recommendation:** Proceed | Proceed with changes | Defer | Reject | Pursue alternative



## TL;DR



<3–5 sentences. Headline recommendation and why. A busy reader stops here.>



## Recommendation



**Verdict:** <Proceed | Proceed with changes | Defer | Reject | Pursue alternative>



<One short paragraph explaining the verdict.>



## How the cases balance



| Lens | Weight | Key takeaway |

|---|---|---|

| For | <high/medium/low> | <one line from pro> |

| Against | <high/medium/low> | <one line from con> |

| Lateral | <high/medium/low> | <one line from lateral> |



## Options



### Option 1: <label> (recommended | alternative)

<2–3 sentences. What to do, expected outcome, main risk.>



### Option 2: <label>

...



## If you proceed



1. <Concrete next step>

2. <Concrete next step>

3. <What to validate first>



## If you defer or reject



<What to do instead — often drawn from lateral alternatives.>



## Deep dives



- [Arguments for](pro.md)

- [Arguments against](against.md)

- [Lateral alternatives](lateral.md)

```



## Chat delivery rules



- Lead with **Recommendation** and **TL;DR** — not process narration.

- Keep chat body under ~250 words unless the user asked for depth.

- Always include markdown links to all four artifact files (use repo-relative paths).

- Do not repeat full analyst arguments in chat — synthesize and point to files.

