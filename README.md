# agent-dotfiles

Portable preferences shared by Claude Code and Codex. The topic files in this
repository are the canonical source; `make apply` renders the configuration
for both agents.

## Prerequisites

- POSIX shell, `make`, and standard Unix tools.
- Bats Core 1.5 or newer for `make test`. On macOS, install it with
  `brew install bats-core`; on other platforms, use the installation guidance
  at <https://github.com/bats-core/bats-core>.

## Commands

```sh
make apply
make test
```

`make apply` checks all topic files, renders both generated documents, checks
for conflicts, and installs each regular file atomically. It uses the current
home directory by default. `DEST_HOME`, `AGENTS_FILE`, and `TOPIC_FILES` can be
overridden when applying to another location or testing.

`make test` runs the Bats integration suite. Tests use temporary destinations
and do not modify the real Claude Code or Codex configuration.

## Installed layout

The repository keeps topics as separate files and the Makefile's ordered
`TOPIC_FILES` list controls their order:

```
<repository>/
├── commits.md
├── task-starting.md
├── planning.md
└── code-comments.md

$HOME/.claude/CLAUDE.md
└── @<absolute repository path>/<topic>.md

<repository>/.agents/AGENTS.md
└── concatenated topics (generated and ignored by Git)

$HOME/.codex/AGENTS.md
└── absolute symlink to <repository>/.agents/AGENTS.md
```

Claude Code reads the absolute `@`-imports in `$HOME/.claude/CLAUDE.md`.
Codex does not support those imports, so its generated `.agents/AGENTS.md`
contains the topic files concatenated in `TOPIC_FILES` order. The Codex
configuration is an absolute symlink to that generated file.

## Ownership and conflicts

Every generated document starts with this exact first line:

```markdown
<!-- managed-by: agent-dotfiles -->
```

A regular destination is managed only when that marker is its first line.
Managed files refresh without prompting. A marker later in the file does not
establish ownership.

An existing unmanaged regular file, or a Codex symlink that does not already
point to the configured `AGENTS_FILE`, is shown with a unified diff and a
`Replace unmanaged ...? [y/N]` prompt. Only `y` or `Y` approves replacement;
`n`, any other answer, or end-of-file aborts before installation, leaving all
destinations unchanged. Directories and other unsupported destination types
are rejected. For a broken Codex symlink, `make apply` prints its raw symlink
target and compares the desired file with `/dev/null` before prompting.

## Adding a topic

1. Create a readable Markdown file in the repository.
2. Add its filename to `TOPIC_FILES` in the Makefile, in the desired order.
3. Run `make apply` and commit the topic and Makefile changes.

The ordered list drives both Claude's imports and Codex's concatenated output,
so no generated file needs to be edited by hand.

## CI and GitHub Actions billing

GitHub Actions uses standard GitHub-hosted runners for this repository's
Ubuntu and macOS matrix. Public repositories receive free and unlimited use of
standard runners; private repositories use the account's included allowance,
with billing possible after it is exhausted. See [GitHub Actions product
billing](https://docs.github.com/en/billing/concepts/product-billing/github-actions).

## What belongs in here

See [`CLAUDE.md`](./CLAUDE.md): general, portable development practices only,
never work- or job-specific content.
