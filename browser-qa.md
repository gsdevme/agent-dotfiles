# Browser QA with screenshots and videos

When a change touches a user-visible UI — anything you would cover with UI or
e2e testing — verify it in a real browser with an AI browser-automation tool
and capture evidence. In Claude Code prefer the cmux browser CLI
(`cmux browser …`) when running inside cmux: it is scriptable from Bash,
screenshots straight to a path, and keeps the QA out of the user's own Chrome.
Use claude-in-chrome when cmux is not available, or for anything that needs
the user's logged-in browser session. In other agents use whatever browser
automation is available (for example Playwright). Backend-only and CLI
changes are exempt.

## Where to capture

Try local first. Run the app on localhost from the project's dev stack and
capture both halves of the pair there: the base-branch build (or the pinned
release image the stack ships with) for *before*, and the fixed build for
*after*. Fall back to staging or production only when the local stack cannot
reproduce the state (missing data, third-party integration, auth). Project
`CLAUDE.md` or memory may name the exact mechanism — for example running a
PR's preview image inside the local dev stack — so check before choosing.

## Before/after screenshots

- Capture **before** screenshots on the base branch *before* making the
  change, so the baseline exists when you need it.
- Capture **after** screenshots once the change is in place, from the same
  pages at the same viewport, so the pair is directly comparable.
- Name files so the pair is obvious: `<area>-before.png`, `<area>-after.png`.
  Keep them in the session scratchpad, not the repository working tree, unless
  the project has an established screenshot directory.
- Cover the states that matter: default, plus loading/empty/error where
  relevant, and mobile width if the change is responsive.

## Before/after videos for interactions

A screenshot shows a state; it cannot show that clicking a control did
nothing. When the change or the bug is about a *sequence* — click this, then
that, and watch what happens — record an annotated before/after video pair in
addition to (or instead of) screenshots. Same rules as screenshots: before on
the base-branch build, after on the fixed build, same page and viewport,
scratchpad not working tree, `<area>-before.mp4` / `<area>-after.mp4`.

Build the video from scripted frames rather than screen-recording a window:
the script is repeatable, the pair is directly comparable, and every frame can
carry a caption.

- **Drive the UI from a script.** Reload the page, dismiss cookie banners,
  then perform the steps. Capture 2 to 4 frames per step with the browser
  tool's screenshot command and write a sibling caption file per frame.
- **Make each click visible.** Before clicking, inject a fixed-position
  highlight ring and a cursor glyph over the target's bounding rect (a few
  lines of `eval` JavaScript), capture two frames, remove the overlay, click,
  then capture the result frames. A viewer should see *what* was clicked,
  then *what happened*.
- **Caption with evidence, not narration.** Two lines per frame: the action
  (`Step 3 · Click the 6M timeframe` / `Step 3 · After clicking 6M`) and the
  live state read from the page or the app's JS objects after the click (for
  a chart: periodicity, visible span, bar count). Tag every frame BEFORE with
  the version or AFTER with the PR/preview build so a frame cannot be
  mistaken for the other half of the pair.
- **Assemble.** Burn captions into a bar below each frame (ImageMagick
  `-splice` + `-annotate` with a font *file* path; Homebrew ffmpeg lacks
  `drawtext`), then encode with ffmpeg at about 1.5 fps, `libx264`,
  `yuv420p`, even dimensions. Under a minute and under a few MB.
- **Only make clicks a real user could make.** Force-clicking a disabled
  control through the DOM leaves stale UI state and produces a misleading
  recording. If a step needs a precondition (select 1Y before Monthly becomes
  enabled), script the precondition as its own step.
- **Record after on a built artefact where you can.** A PR preview image run
  in the local stack shows what will ship; a hot-reloading dev server is the
  fallback when no built artefact is available.

## Attach them to the tracking artefact

Attach the pair wherever the ticket is tracked so reviewers see evidence
without re-running the app:

- **GitHub PR** — always. Put them in the PR description under a
  "Before / After" heading (a two-column Markdown table works well for
  images; videos go one per line so GitHub renders a player). Upload them as
  PR attachments; don't commit them to the repository. Upload with
  claude-in-chrome, which is signed in as the user: `find` the PR comment
  box's hidden file input, `file_upload` the files, read the resulting
  `user-attachments/assets` URLs from the textarea, clear the draft, then put
  the URLs in the description with `gh pr edit --body-file`. The cmux
  browser is not signed in to GitHub, so it cannot do this step.
- **GitHub Issue** — when the issue is the tracking record, also add a comment
  with the screenshots when linking or closing it from the PR.
- **Jira** — when the ticket is in Jira, attach the images or videos to the
  issue (one REST call to `/rest/api/3/issue/KEY/attachments`, or
  claude-in-chrome on the issue page) and add a short comment summarising
  what changed, linking the PR.
  Reference an attachment from the comment as `[^name.mp4]`. If a recording
  is superseded, upload the new one under a new name and say which one is
  current; don't rely on being able to delete the old one.

Use whichever of these the project actually uses for the ticket. If a project
tracks in Jira but reviews in GitHub, do both (PR + Jira).

## Keep it honest

- Screenshots and videos are evidence, not decoration: if the after state is
  wrong, say so and fix it before attaching.
- Captions describe what the frame shows. If a step reveals a limitation
  (something still does not work), caption it as such rather than cutting
  the step, and re-check the limitation is real before writing it up as one.
- Don't fake, crop, or retouch. If a state can't be reproduced, say which one
  and why.

Project-level `CLAUDE.md` may override this.
