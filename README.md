# claude-dotfiles

Personal Claude Code preferences, kept in git so they're portable across machines.

Each file is a single topic (commits, task-starting, …). They're imported into `~/.claude/CLAUDE.md` by absolute path so Claude Code picks them up globally.

To add a new topic:

1. Create `~/claude-dotfiles/<topic>.md`.
2. Add `@/Users/gavin/claude-dotfiles/<topic>.md` to `~/.claude/CLAUDE.md`.
3. Commit.
