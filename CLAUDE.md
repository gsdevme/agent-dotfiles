# Repo guidance

This repo holds **general, portable** Claude Code preferences — good
development practices that apply across any codebase, employer, or project.

## Do not add work- or job-specific content here

Examples of what does **not** belong:

- Company-specific conventions, tooling, or workflows
- Project-specific build, deploy, or test steps
- Internal URLs, ticket systems, code-owners, team names
- Credentials, secrets, or anything covered by an NDA or employment agreement
- Names of internal services, libraries, or people

Work-specific guidance belongs in that project's own `CLAUDE.md` (checked into
the project's repo), or in a separate work-only dotfiles repo — not here.

## The test

If you're not sure whether something belongs, ask: *would this advice make
sense to a developer at any company, on any codebase?*

- Yes → it belongs here.
- No → it goes in the project repo or a work-only location.
