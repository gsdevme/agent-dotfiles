REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DEST_HOME ?= $(HOME)
AGENTS_FILE ?= $(REPO_ROOT)/.agents/AGENTS.md
TOPIC_FILES := models.md commits.md task-starting.md planning.md code-comments.md

.PHONY: apply test

apply:
	@DEST_HOME="$(DEST_HOME)" \
		AGENTS_FILE="$(AGENTS_FILE)" \
		REPO_ROOT="$(REPO_ROOT)" \
		TOPIC_FILES="$(TOPIC_FILES)" \
		sh "$(REPO_ROOT)/scripts/apply.sh"

test:
	@if ! command -v bats >/dev/null 2>&1; then \
		printf '%s\n' 'Bats Core 1.5+ is required. Install it with brew install bats-core or see https://github.com/bats-core/bats-core.' >&2; \
		exit 1; \
	fi; \
	bats_version="$$(bats --version | sed -n 's/.* \([0-9][0-9.]*\).*/\1/p')"; \
	if ! awk -v version="$$bats_version" 'BEGIN { split(version, v, "."); exit !(v[1] > 1 || (v[1] == 1 && v[2] >= 5)) }'; then \
		printf '%s\n' 'Bats Core 1.5+ is required. Install it with brew install bats-core or see https://github.com/bats-core/bats-core.' >&2; \
		exit 1; \
	fi; \
	bats "$(REPO_ROOT)/tests/apply.bats"
