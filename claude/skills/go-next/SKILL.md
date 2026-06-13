---
name: go-next
description: Use when the user says "go next", "move to next", "what's next", "continue", "resume", "pick up where we left off", or otherwise signals start-of-session or next-slice in the claude-workspace (ready-to-fly + travel-id-verify) and expects orientation from prior context before any work.
---

# Go Next

Opening bookend for a work session in the two-repo Ready-to-Fly workspace (`ready-to-fly` + `travel-id-verify`). You start cold; "go next" means **orient from prior context, pick the right frontier, and plan it — before touching code.** Pairs with `conclude-session` (the closing bookend).

**FIRST ACTION: create a TodoWrite with one item per step below, then work them in order.** Do not jump straight to editing — guessing the next slice from a cold start is the failure this skill prevents.

Standing context to honor: `[[project_rtf_system_map]]`, `[[project_rtf_progress]]`, `[[project_rtf_design_pillars]]`, `[[feedback_plan_before_execution]]`, `[[feedback_completion_note_filename]]`, `[[feedback_two_repo_sync_and_dod]]`.

## The steps (in order)

### 1. Orient — read the start-of-session context leanly (sections, not whole files)
Front-loaded reads ride along in **every** later turn this session, so pull only the slice you need. Most orientation context is already injected — don't re-read it.
- **RTF memory:** the 3 files' summaries are already injected via `MEMORY.md` at session start — rely on those. Deep-read `project_rtf_system_map` / `project_rtf_progress` / `project_rtf_design_pillars` **only** for a detail the summary doesn't carry.
- **`ready-to-fly/docs/SESSIONS.md` → read the "Current focus" + roadmap** (the file is now lean — current slice, what's-next, and a one-line "Recently shipped" index; ~50 lines). Authoritative, read it first. Deep per-slice history lives in `SESSIONS-archive.md` — do NOT open it unless you're tracing a specific past slice.
- **`ENHANCEMENTS.md` → read ONLY the top deferred-follow-ups block** (down to the first phase heading) for `[REQUIRED]` items.
- **`CLAUDE.md` (working principles + gotchas) → only the repo(s) this slice touches.** Same for `travel-id-verify/docs/SESSIONS.md` — only if the work touches tiv.

### 2. Check the working state of both repos — catch dangling work from a prior session
Run in the workspace root (`/Users/msamir/Coding/claude-workspace`):
```bash
for r in ready-to-fly travel-id-verify; do
  echo "== $r =="
  echo "branch: $(git -C "$r" branch --show-current)"
  git -C "$r" status --short                          # uncommitted / untracked
  git -C "$r" log --oneline @{u}..HEAD 2>/dev/null    # unpushed commits on current branch
  git -C "$r" branch --no-merged main                 # local feature branches not merged to main
done
```
- If you find **uncommitted/untracked work**, an **unmerged feature branch**, or **unpushed commits**: surface it and ask whether to finish it first (commit / push / merge — i.e. run `conclude-session` on the prior work) **before** starting the new slice. Don't start fresh work on a dirty tree or stack new work on an unfinished branch.
- Note any change the user didn't make (e.g. a stray modified file) rather than silently building on it.
- Clean tree on `main` in both repos = good to proceed.

### 3. Reconcile and find the frontier
- If memory and `SESSIONS.md` disagree, **`SESSIONS.md` "Current focus / Next" wins** (it changes most often).
- Surface any `[REQUIRED]` follow-up that may outrank the headline "next" (e.g. a promotion/authoritative-flip gate, a deferred on-device test, a pending migration).

### 4. Confirm the slice before planning
- If the next slice is unambiguous (`SESSIONS` says "Next focus → X"): state it in one line and confirm.
- If sequencing is "TBD" or there are multiple candidates: **ask the user to pick** (AskUserQuestion). Do not guess which slice.

### 5. Pre-work setup
- Ensure an isolated workspace: a **feature branch** off `main` (never edit `main` directly). Match the repo's branch-naming convention.
- **Ask the user for the exact completion-note filename** (`docs/completion-notes/xxx-phaseN-xxx.md`) — never infer it from the existing numbering.

### 6. Plan before execution
- Propose the **smallest viable plan**: numbered steps, concrete files, in-scope vs deferred, success criteria. Get an explicit yes before any non-trivial edit.
- Then hand off to execution (`ce-plan` / `superpowers:subagent-driven-development` / `executing-plans`) as fits the work.

## Red flags — STOP, you're skipping orientation
| You're about to… | Instead |
|---|---|
| Start editing right after "go next" | Orient first (step 1); the frontier lives in SESSIONS + memory |
| Read whole SESSIONS.md / ENHANCEMENTS.md / memory files | Pull sections only (step 1) — front-loaded reads re-bill every later turn |
| Start new work without checking repo state | Run step 2; finish/commit/push/merge dangling prior work first |
| Build on a dirty tree or unmerged branch you didn't expect | Surface it to the user; don't silently stack on it |
| Assume the next slice from memory alone | Confirm against `SESSIONS.md` "Current focus" — it wins |
| Pick a slice when sequencing is "TBD" | Ask the user which one |
| Begin work on `main` | Branch first |
| Infer the completion-note filename | Ask the user |
| Make non-trivial edits before agreeing a plan | Propose the plan, get a yes, then execute |
