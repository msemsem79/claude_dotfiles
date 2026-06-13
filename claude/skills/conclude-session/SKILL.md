---
name: conclude-session
description: Use when the user says "conclude the session", "wrap up the session", "close out the session", "end the session", or otherwise signals end-of-session in the claude-workspace (ready-to-fly + travel-id-verify) and expects docs, memory, and git to be finalized.
---

# Conclude the Session

End-of-session finalization for the two-repo Ready-to-Fly workspace (`ready-to-fly` + `travel-id-verify`). Runs a fixed checklist so **no step is ever missed**: verify → docs → memory → git → honest wrap-up. Skipping a step is a failure, even under "it's a small change" or "we're out of time" pressure.

**FIRST ACTION: create a TodoWrite with one item per checklist step below, then work them in order.** The todo list is the mechanism that prevents dropped steps — do not work from memory.

Standing context to honor: `[[feedback_two_repo_sync_and_dod]]`, `[[feedback_conclude_with_honest_sessions_update]]`, `[[feedback_completion_note_filename]]`, `[[feedback_plan_before_execution]]`.

## The checklist (in order)

### 1. Verify — evidence before claims
- Run **both** repos' full test suites + builds. Paste real pass/fail counts (node is via nvm: `. "$HOME/.nvm/nvm.sh"`).
- Run smoke / E2E as far as the env allows: bring the stack up yourself (`start.sh` + `dev-mobile.sh`). A down stack / empty DB is the normal resting state, not a bug — bring it up, don't diagnose it.
- Flag any required reseed / DB migration; update `start.sh` / `dev-mobile.sh` / `stop.sh` if bring-up changed.
- Never fabricate verification. State explicitly what is verified vs. what still needs the user's on-device check.

### 2. Docs — update every applicable file, in BOTH repos when the change is cross-repo
- **Completion note** `docs/completion-notes/xxx-phaseN-xxx.md` — **ASK the user for the exact filename; never infer it.**
- **SESSIONS.md** — keep it LEAN (go-next reads it every session): "Current focus" holds only the in-flight slice + what's-next/roadmap, honest verified-vs-unverified. When a slice reaches DONE+MERGED, move its full block into `SESSIONS-archive.md` (newest first) and leave a one-liner in the "Recently shipped" index with its completion-note link. Don't let "Current focus" accumulate finished blocks.
- **VERIFIED.md** — append ONLY what the user actually confirmed (ask first if an update is warranted).
- **ENHANCEMENTS.md** — deferred follow-ups with `[REQUIRED]` / `[NICE-TO-HAVE]` / `[LOW]` labels.
- **DECISIONS.md / ADRs** — record non-obvious decisions and any deviation from the plan.

### 3. Memory sync (the step most easily forgotten)
- Update affected files in the memory folder (`project_rtf_progress`, `project_rtf_system_map`, `project_rtf_design_pillars`, plus any new feedback/reference) AND their `MEMORY.md` index hooks.
- Confirm `MEMORY.md` is in sync: every file is linked, every link resolves, no stale claims (e.g. "frontier = X" after X shipped).

### 4. Git
- Commit on the **feature branch** with clear messages + the `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>` footer.
- **Push the branch to remote — always part of conclude.**
- **Merge to `main` ONLY if the user explicitly said to.** Otherwise leave the branch / offer a PR.

### 5. Honest wrap-up message
- What shipped; verified vs. the explicit remaining manual gate; next focus; housekeeping (stack left up/down, test-data rows added, deps changed, files touched outside scope).

## Red flags — STOP, you're about to miss a step
| You're about to… | Instead |
|---|---|
| Send the wrap-up without touching the memory folder | Do step 3 first — memory sync is mandatory, not optional |
| Say "tests probably still pass" | Run them (step 1) and paste counts |
| Call a feature "verified" you only built/typechecked | Say plainly what's unverified; name the device gate |
| `git push`/merge reflexively | Push the branch yes; merge to main only on explicit instruction |
| Infer the completion-note filename | Ask the user |
| Update only one repo for a cross-repo change | Mirror docs/code across both repos |

Letter vs. spirit: doing 4 of 5 steps is not "basically concluded" — it is an incomplete conclude. Run all five.
