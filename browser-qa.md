# Browser QA with screenshots

When a change touches a user-visible UI — anything you would cover with UI or
e2e testing — verify it in a real browser with an AI browser-automation tool
and capture evidence. In Claude Code that tool is claude-in-chrome; in other
agents use whatever browser automation is available (for example Playwright).
Backend-only and CLI changes are exempt.

## Before/after screenshots

- Capture **before** screenshots on the base branch (or production/staging)
  *before* making the change, so the baseline exists when you need it.
- Capture **after** screenshots once the change is in place, from the same
  pages at the same viewport, so the pair is directly comparable.
- Name files so the pair is obvious: `<area>-before.png`, `<area>-after.png`.
  Keep them in the session scratchpad, not the repository working tree, unless
  the project has an established screenshot directory.
- Cover the states that matter: default, plus loading/empty/error where
  relevant, and mobile width if the change is responsive.

## Attach them to the tracking artefact

Attach the pair wherever the ticket is tracked so reviewers see evidence
without re-running the app:

- **GitHub PR** — always. Put them in the PR description under a
  "Before / After" heading (a two-column Markdown table works well). Upload
  them as PR attachments; don't commit them to the repository.
- **GitHub Issue** — when the issue is the tracking record, also add a comment
  with the screenshots when linking or closing it from the PR.
- **Jira** — when the ticket is in Jira, attach the images to the issue and
  add a short comment summarising what changed, linking the PR.

Use whichever of these the project actually uses for the ticket. If a project
tracks in Jira but reviews in GitHub, do both (PR + Jira).

## Keep it honest

- Screenshots are evidence, not decoration: if the after state is wrong, say
  so and fix it before attaching.
- Don't fake, crop, or retouch. If a state can't be reproduced, say which one
  and why.

Project-level `CLAUDE.md` may override this.
