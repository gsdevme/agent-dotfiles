# Commit messages

Always use Conventional Commits / semantic commit format for any commit you author.

- Format: `type(scope): subject` — scope optional, subject in imperative mood, no trailing period.
- Allowed types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `revert`.
- **Do not use `chore`** — pick a more specific type. If nothing else fits, prefer `refactor`, `build`, or `ci` based on what the change actually touches.
- Use `!` after type/scope or a `BREAKING CHANGE:` footer for breaking changes.
- Keep the subject ≤72 characters; put detail in the body separated by a blank line.
- Examples:
  - `feat(auth): add refresh-token rotation`
  - `fix: handle empty response from billing API`
  - `refactor(parser)!: drop legacy YAML loader`

## Atomic commits

Default to **one atomic commit per atomic change**. A single logical change — a feature, a fix, a refactor — should land as a single commit, not a chain of "wip", "address review", "fix typo" commits.

- When iterating on PR feedback, rebase and squash the fixups into the original commit, then force-push (prefer `--force-with-lease`) so the branch stays a single commit.
- Do not add follow-up "review fixes" commits to a PR branch — amend or squash instead.
- Exception: if a PR genuinely contains multiple independent atomic changes, keep them as separate commits (one per change), and squash review fixups into whichever commit they belong to.
- Never force-push to shared branches (`main`, `master`, release branches). Force-push only applies to your own feature/PR branch.

Project-level `CLAUDE.md` may override this.
