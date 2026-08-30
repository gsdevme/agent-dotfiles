# Code comments

Code should explain itself. When something genuinely needs explaining, prefer
a documentation block attached to a structure over comments scattered through
the code.

## Prefer doc blocks over inline comments

Attach explanations to the file, class, function, or method using the
language's documentation convention (JSDoc/TSDoc, docstrings, rustdoc, PHPDoc,
GoDoc, XML doc comments, …):

- **File/module block** — why the module exists and how it fits into the
  wider system.
- **Class block** — the responsibility of the class and how it's meant to be
  used.
- **Function/method block** — behaviour, parameters, return values, and any
  caveats that matter to callers.

Doc blocks live at a stable, discoverable anchor — IDE hover, generated docs,
the top of the unit. Keeping the explanation attached to the unit makes it
easier to find and less likely to drift than a detached inline comment.

## Keep code bodies lean

Avoid verbosity inside the code itself:

- Don't narrate what the next line does; the code already says it.
- Don't record change history or justify an edit in a comment — that belongs
  in the commit message or PR description.
- No commented-out code. Delete it; git remembers.
- If a body needs running commentary to be understood, refactor instead:
  extract a well-named function and document *that* with a block.

An inline comment is justified only for a constraint the code cannot express:
a non-obvious invariant, a workaround (with a link to the upstream issue), or
a deliberate deviation from the approach a reader would expect.

## Exception: YAML

YAML (CI pipelines, Kubernetes manifests, docker-compose, …) has no doc-block
construct and little naming to lean on — comments are its only documentation
mechanism. Comment YAML as generously as needed: non-obvious keys, magic
values, and why settings are set the way they are. The same applies to other
comment-only config formats.
