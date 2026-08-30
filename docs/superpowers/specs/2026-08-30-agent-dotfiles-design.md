# Agent Dotfiles Setup Design

## Goal

Keep the existing topic files as the single source of truth while making the
same global preferences available to Claude Code and Codex. A single
`make apply` command will install both configurations safely on macOS and
Linux.

## Source and generated files

The root topic files remain canonical and ordered explicitly in the Makefile:

1. `commits.md`
2. `task-starting.md`
3. `planning.md`
4. `code-comments.md`

Claude continues to use its native `@`-import syntax. `make apply` renders
`~/.claude/CLAUDE.md` with absolute imports for each topic file. This wrapper
is machine-specific because Claude requires literal absolute paths.

Codex does not support `@`-imports. `make apply` concatenates the topic files,
in the same order, into `.agents/AGENTS.md`, then creates
`~/.codex/AGENTS.md` as an absolute symlink to that generated file.
`.agents/AGENTS.md` is ignored by Git because it duplicates the canonical
topic files.

Both generated documents begin with:

```markdown
<!-- managed-by: agent-dotfiles -->
```

Generated text, terminal output, and documentation use the tool-neutral name
"agent dotfiles" and do not hardcode the repository's current directory name.

## Makefile interface

The Makefile provides two public targets:

- `make apply` renders and installs the Claude and Codex configuration.
- `make test` runs the Bats test suite, or exits with a concise installation
  hint when `bats` is unavailable.

The Makefile derives the repository's absolute location from its own path.
Tests may override the destination home and generated `AGENTS.md` path so they
never modify the developer's real configuration.

Adding another topic requires adding its filename to the ordered Makefile
list. Both Claude imports and Codex concatenation then update together.

## Safe application and conflict handling

The apply script first renders all desired content in a temporary directory.
Before changing anything, it examines:

- `~/.claude/CLAUDE.md`
- the generated `.agents/AGENTS.md`
- `~/.codex/AGENTS.md`

A missing destination is safe to create. A regular file whose first line is
exactly the ownership marker, or an already-correct Codex symlink, is safe to
refresh without a prompt. A marker appearing later in a file does not
establish ownership.

For an existing unmanaged regular file or wrong Codex symlink, the script
prints a unified diff between the existing and desired content and asks
whether to replace it with a `[y/N]` prompt. Only `y` or `Y` approves
replacement. A broken symlink's raw target is printed and its diff uses
`/dev/null` as the existing side. A negative response, end-of-file, or
non-interactive invocation without input aborts with a nonzero status and
leaves every destination unchanged.

Directories or other unsupported destination types produce an error and are
never replaced. All conflict decisions happen before installation begins, so
declining a later conflict cannot leave a partially updated configuration.

After preflight succeeds, regular files are installed atomically through a
temporary sibling followed by a rename. The Codex symlink is likewise replaced
only after all checks pass. Re-running `make apply` is idempotent.

## Test design

The shell integration tests use Bats Core and exercise the public `make apply`
interface against isolated temporary home and generated-file paths. They use
real filesystem operations rather than mocks.

The suite covers:

- fresh installation of both agent configurations;
- Claude's absolute `@`-imports and their declared order;
- Codex concatenation and its declared order;
- the ownership marker in both generated documents;
- creation of the absolute Codex symlink;
- idempotent refresh of managed files without prompting;
- rejection of an unmanaged conflict, including the displayed diff, nonzero
  exit, and absence of partial writes;
- confirmed replacement of an unmanaged conflict;
- safe behavior when stdin reaches EOF; and
- errors for unsupported destination types.

The tests clean up only temporary directories they create themselves.

## Continuous integration

GitHub Actions runs `make test` for pushes and pull requests with a matrix of
`ubuntu-latest` and `macos-latest`. The workflow uses the official
`bats-core/bats-action` to install Bats Core without adding Node project files
or vendoring test dependencies. No Bats helper libraries are required.

Standard Ubuntu and macOS GitHub-hosted runners are free and unlimited for
public repositories. Private repositories can use both within the account's
included GitHub Actions allowance. The workflow does not use larger runners,
artifacts, or caches.

## Documentation changes

The README will describe the repository as preferences shared across coding
agents while retaining its current repository name. It will document:

- prerequisites and local Bats installation;
- `make apply` and `make test`;
- the Claude import and Codex concatenation layouts;
- generated-file ownership and interactive conflict handling; and
- how to add a topic through the ordered Makefile list.

## Alternatives considered

Installing Bats separately with Homebrew and APT in CI would avoid an action,
but creates platform-specific setup and may select different package versions.
Using the official Bats action gives both runners the same test harness.

Adding Bats as an npm development dependency would also be cross-platform, but
would introduce `package.json`, a lockfile, and Node dependency management to a
repository that otherwise has no Node tooling.

Vendoring Bats would make tests self-contained at the cost of copying and
maintaining a substantial third-party codebase. The official action plus a
documented local prerequisite is the smallest maintainable option.
