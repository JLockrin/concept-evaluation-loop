# Evaluation artifacts



Structured outputs from the **concept-evaluation-loop** skill.



## Layout



**Concept mode** (single evaluation):



```

evaluations/<eval-id>/

  brief.md

  pro.md, cons.md, lateral.md, synthesis.md

```



**Problem mode** (brainstorm + evaluate each):



```

evaluations/<eval-id>/

  brief.md

  approaches.md

  option-a/  → brief.md, pro.md, cons.md, lateral.md, synthesis.md

  option-b/

  option-c/

  meta-synthesis.md

```



Projects using a Codex harness may use `.codex-harness/evaluations/` instead — the skill auto-detects.



Default **3** approaches in problem mode. Max **5**. Orchestrator chooses count (2–5) unless `--options` is set. Mode is auto-detected from input.



## Eval ID



`<subject-slug>-YYYY-MM-DD` — kebab-case from the subject line. Append `-2`, `-3`, etc. on collision.



## Lifecycle



- Created per `/concept-evaluation-loop` run.

- Referenced in chat via repo-relative markdown links.

- Material evaluations may be noted in `brain/domains/concept-evaluation/README.md` Timeline (optional).



## Analyst isolation



Each sub-agent receives **only** `brief.md`. Pro, con, and lateral run in parallel without cross-reading.

