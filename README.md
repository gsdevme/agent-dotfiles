# claude-dotfiles

Personal Claude Code preferences, kept in git so they're portable across
machines.

## Why a separate repo?

`~/.claude/` is Claude Code's own working directory — it stores active
projects, plans, agents, MCP server caches, and other ephemeral tooling
state. Mixing personal preferences in there means:

- Real preferences get lost in the noise of generated files.
- Versioning and diffing the rules I actually care about is awkward.
- Syncing to a new machine is messy — most of `~/.claude/` shouldn't be
  copied across, but a few files should.

Pulling preferences into a dedicated repo fixes all of that:

- `~/.claude/` stays clean and untracked-by-design.
- Preferences are portable: `git clone` on a new machine gets them all.
- Real history, diffs, and rollback for the rules Claude follows.
- Easier to share or review specific rules without dragging along
  whatever's sitting in `~/.claude/projects/` at the time.

## How it works

Each file in this repo is one topic (`commits.md`, `task-starting.md`, …).
They're pulled into Claude Code's global config via `@`-imports in
`$HOME/.claude/CLAUDE.md`, so Claude picks them up as global preferences.

Layout:

```
$HOME/claude-dotfiles/
├── commits.md
├── task-starting.md
└── ...

$HOME/.claude/CLAUDE.md
└── @-imports each file above by absolute path
```

## Adding a new topic

1. Create `$HOME/claude-dotfiles/<topic>.md`.
2. Add an `@`-import line for it to `$HOME/.claude/CLAUDE.md`. Note: `@`-imports
   require a literal absolute path (they don't expand `~` or `$HOME`), so the
   line will look like `@/Users/<you>/claude-dotfiles/<topic>.md`.
3. Commit.

## What belongs in here

See [`CLAUDE.md`](./CLAUDE.md) — short version: general, portable dev
practices only, never work- or job-specific content.
