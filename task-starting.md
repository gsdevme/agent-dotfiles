# Task starting

When starting a new task or prompt that will involve code changes inside a git repository, before writing or editing any code:

1. **Check the current branch.** Run `git rev-parse --abbrev-ref HEAD`. If the working directory is not a git repository, or the repo has no `main`/`master` branch, skip the rest of these steps.

2. **Fetch the canonical branch.** Run `git fetch origin main` (or `git fetch origin master`, whichever the repo uses). This updates remote-tracking refs only — it does not modify the working tree, local branches, or merge anything.

3. **If not on `main`/`master`, confirm the base branch with the user.** State the current branch and ask whether to:
   - Continue the new work on top of the current feature branch, or
   - Switch to `main`/`master` first and start a fresh branch from the latest.

   Always ask — do not infer the answer from the branch name or recent activity.

4. **Apply once per task, not per tool call.** This check runs at the start of a new task. Once the base branch is established for the current task, proceed without re-asking on follow-up prompts within the same task.

## Large multi-phase work: epic + phase issues

When a task is too big for one or a few PRs — a migration, a version-upgrade
ladder, a staged rollout, anything spanning many PRs over weeks — suggest
tracking it as GitHub issues before starting implementation:

1. **One issue per phase**, each a self-contained, actionable checklist sized
   to one or a few PRs, with explicit exit criteria at the end.
2. **One tracking epic issue** that carries the overall strategy, any
   standard per-step procedure (so it isn't repeated in every phase issue),
   and a task-list of the phase issues (`- [ ] #NN`) so GitHub auto-tracks
   progress as they close.
3. **A dedicated label** (create it if needed) grouping the whole series.
4. Cross-link: each phase issue's opening line references the epic.

Create the issues with `gh issue create --body-file` (draft bodies as local
scratch files first — they are local-only context per the planning rules).
Confirm with the user before creating issues; once agreed, create the full
series in one go rather than one at a time.
