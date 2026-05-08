# Task starting

When starting a new task or prompt that will involve code changes inside a git repository, before writing or editing any code:

1. **Check the current branch.** Run `git rev-parse --abbrev-ref HEAD`. If the working directory is not a git repository, or the repo has no `main`/`master` branch, skip the rest of these steps.

2. **Fetch the canonical branch.** Run `git fetch origin main` (or `git fetch origin master`, whichever the repo uses). This updates remote-tracking refs only — it does not modify the working tree, local branches, or merge anything.

3. **If not on `main`/`master`, confirm the base branch with the user.** State the current branch and ask whether to:
   - Continue the new work on top of the current feature branch, or
   - Switch to `main`/`master` first and start a fresh branch from the latest.

   Always ask — do not infer the answer from the branch name or recent activity.

4. **Apply once per task, not per tool call.** This check runs at the start of a new task. Once the base branch is established for the current task, proceed without re-asking on follow-up prompts within the same task.
