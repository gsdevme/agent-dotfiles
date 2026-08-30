# Planning

Where plans live determines whether they belong in a PR.

## Local plans stay local

Plans written outside the repository working tree — for example in
`~/.claude/`, `~/plans/`, or scratch files in `/tmp` — are **local-only
context**. They exist to help the current session think; they are not
artifacts of the project.

- **Never** reference, link to, paste excerpts from, or quote these local
  plans in a GitHub PR description, commit message, code comment, or
  review reply. Reviewers cannot open them, they are not versioned with
  the code, and the paths are personal to one machine.
- The PR description should stand on its own: summarise the change, the
  motivation, and the test plan inline.

## Critical plans go in the repo

When the *plan itself* is load-bearing — a multi-phase migration, an
architectural decision, a staged rollout, anything future contributors
will need to understand the shape of the work — put it in the repository's
established planning or design location. If the project has no convention,
use `docs/plans/` (create the directory if it doesn't exist).

- Commit the plan alongside the code that implements it (or in a
  preceding commit on the same branch).
- Then it's fine — and encouraged — to link to its repository-relative path
  from the PR description, commit body, or code comments. It's part of the
  repo, so the link is durable and reviewable.

## How to decide

Ask: *would a reviewer or a future contributor need this plan to
understand or maintain the change?*

- Yes → write it into the repo's established location (or `docs/plans/`
  when none exists) and reference it freely.
- No → keep it local and don't mention its path anywhere that ships.

Project-level instructions may override this.
