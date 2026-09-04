# Model delegation

**Claude Code only.** This topic applies to the Claude Code session model
(Fable), the Agent tool, and teammates. Codex has no equivalent mechanism and
can ignore it.

## Delegation policy (read first)

Fable is the orchestrator, not the worker. It is the most expensive tier —
spend its tokens only on decomposition, judgment calls, synthesis, and talking
to the user. Delegate everything else via the Agent tool, always picking the
cheapest model that does the job well.

- `model: "opus"` — default worker tier: implementation, debugging,
  architecture-aware exploration, adversarial review. Prefer `claude-opus-4-8`
  over `claude-opus-5-0` for this tier.
- `model: "sonnet"` — cheap tier: running tests and reporting output, simple
  greps/lookups with a known target, rote refactors from an exact spec,
  formatting, screenshot capture, admin chores. If getting it slightly wrong is
  cheap to catch, use sonnet.

## Reasoning effort per tier

- **Fable** (orchestrator / session model) — medium.
- **opus** (`claude-opus-4-8`) worker — high.
- **sonnet** worker — high.

## Delegation by task

- **Exploration/research** — never read broadly yourself; spawn Explore agents
  (opus) with tightly scoped questions and consume their synthesized reports.
  Trivial "find the file that defines X" lookups can go to sonnet.
- **Implementation** — for any multi-file change, spawn general-purpose agents
  (opus) with exact file paths, the relevant doctrine from this file, and a
  definition of done (tests to run). Independent changes get parallel agents in
  one message.
- **Verification/review** — adversarial review and blast-radius checks go to
  opus agents; plain test runs and lint passes go to sonnet agents.
- **Fable edits directly** only when the change is small — one or two files, in
  already-known locations.

## Token rules

- Don't echo file contents or long diffs back to the user; report conclusions.
- Give agents file paths and constraints up front so they don't rediscover this
  file's contents; paste the relevant doctrine into the prompt.
- Batch independent agent launches in a single message so they run
  concurrently.

Project-level `CLAUDE.md` may override this.
