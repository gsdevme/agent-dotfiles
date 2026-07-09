---
name: reconcile-references
description: Use when this repo's topic files and the @import lines in ~/.claude/CLAUDE.md may have drifted out of sync — after adding, renaming, or deleting a topic .md file, when setting up a new machine, or when the user asks to check, sync, or reconcile imports.
---

# Reconcile references

Ensure every topic file in this repo is `@`-imported by `$HOME/.claude/CLAUDE.md`,
and every import that points into this repo resolves to a real file.

## Definitions

- **Topic file**: a `*.md` file at the repo root, excluding `README.md` and
  `CLAUDE.md` — those two are repo documentation and must never be imported.
  Files in subdirectories are not topics.
- **Repo-pointing import**: a line in `$HOME/.claude/CLAUDE.md` beginning with
  `@` whose path resolves inside this repo. Any other import (e.g. `@RTK.md`,
  which resolves to `$HOME/.claude/RTK.md`) is out of scope: never add, edit,
  remove, or report on it.

## Procedure

1. **Collect both sides.** List topic files at the repo root; extract the
   repo-pointing imports from `$HOME/.claude/CLAUDE.md`.
2. **Add missing imports.** For each topic file with no import, append
   `@/absolute/path/to/<topic>.md` to the existing import block, keeping the
   block's order and surrounding blank lines intact. The path must be a
   literal absolute path — `@`-imports do not expand `~` or `$HOME`. No
   confirmation needed; adding is always safe.
3. **Investigate stale imports.** For each repo-pointing import whose target
   is missing from the working tree, determine which case it is before
   touching it:
   - Run `git log --oneline --all -- <file>` and check branches
     (`git cat-file -e <branch>:<file>`) to see whether the file still
     exists on another branch.
   - **Exists on another branch** → branch drift, not staleness. Leave the
     import in place and tell the user which branch has the file.
   - **Gone from every branch** → genuinely deleted or renamed. Propose the
     removal and ask the user to confirm before editing; never remove
     silently.
4. **Report.** End with a short summary: imports added, stale imports (and
   what you did or are asking about), and anything left alone and why.

## Common mistakes

- Importing `README.md` or `CLAUDE.md` — "all the .md files" means all
  *topic* files, not repo docs.
- Touching imports that don't point into this repo.
- Writing `~/claude-dotfiles/...` in an import — the path must be literal
  and absolute.
- Removing a "stale" import that is only missing because the current branch
  doesn't have the file yet.
