---
name: go-next
description: Use when the user says "go next", "move to next", "what's next", "continue", "resume", "pick up where we left off", or otherwise signals start-of-session or next-slice in the claude-workspace (ready-to-fly + travel-id-verify) and expects orientation from prior context before any work.
---

# Go Next

Opening bookend for a work session in the two-repo Ready-to-Fly workspace (`ready-to-fly` + `travel-id-verify`). You start cold; "go next" means **orient from prior context, pick the right frontier, and plan it — before touching code.** Pairs with `conclude-session` (the closing bookend).

**FIRST ACTION: create a TodoWrite with one item per step below, then work them in order.** Do not jump straight to editing — guessing the next slice from a cold start is the failure this skill prevents.

Standing context to honor: `[[project_rtf_system_map]]`, `[[project_rtf_progress]]`, `[[project_rtf_design_pillars]]`, `[[feedback_plan_before_execution]]`, `[[feedback_completion_note_filename]]`, `[[feedback_two_repo_sync_and_dod]]`.

## The steps (in order)

### 1. Orient — read the start-of-session context, in priority order
- The 3 RTF memory files: `project_rtf_system_map` → `project_rtf_progress` → `project_rtf_design_pillars`.
- Both repos' `CLAUDE.md` (working principles + gotchas).
- **`ready-to-fly/docs/SESSIONS.md` "Current focus" — authoritative, read first.** (And `travel-id-verify/docs/SESSIONS.md` if the work touches that repo.)
- Skim the top of `ENHANCEMENTS.md` for deferred `[REQUIRED]` follow-ups.

### 2. Reconcile and find the frontier
- If memory and `SESSIONS.md` disagree, **`SESSIONS.md` "Current focus / Next" wins** (it changes most often).
- Surface any `[REQUIRED]` follow-up that may outrank the headline "next" (e.g. a promotion/authoritative-flip gate, a deferred on-device test, a pending migration).

### 3. Confirm the slice before planning
- If the next slice is unambiguous (`SESSIONS` says "Next focus → X"): state it in one line and confirm.
- If sequencing is "TBD" or there are multiple candidates: **ask the user to pick** (AskUserQuestion). Do not guess which slice.

### 4. Pre-work setup
- Ensure an isolated workspace: a **feature branch** off `main` (never edit `main` directly). Match the repo's branch-naming convention.
- **Ask the user for the exact completion-note filename** (`docs/completion-notes/xxx-phaseN-xxx.md`) — never infer it from the existing numbering.

### 5. Plan before execution
- Propose the **smallest viable plan**: numbered steps, concrete files, in-scope vs deferred, success criteria. Get an explicit yes before any non-trivial edit.
- Then hand off to execution (`ce-plan` / `superpowers:subagent-driven-development` / `executing-plans`) as fits the work.

## Red flags — STOP, you're skipping orientation
| You're about to… | Instead |
|---|---|
| Start editing right after "go next" | Orient first (step 1); the frontier lives in SESSIONS + memory |
| Assume the next slice from memory alone | Confirm against `SESSIONS.md` "Current focus" — it wins |
| Pick a slice when sequencing is "TBD" | Ask the user which one |
| Begin work on `main` | Branch first |
| Infer the completion-note filename | Ask the user |
| Make non-trivial edits before agreeing a plan | Propose the plan, get a yes, then execute |
