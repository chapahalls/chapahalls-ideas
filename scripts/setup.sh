#!/bin/sh
# One-time setup per clone: commit template + hint-only commit-msg hook.
set -e
cd "$(git rev-parse --show-toplevel)"
chmod +x scripts/hooks/commit-msg scripts/roadmap.mjs
git config core.hooksPath scripts/hooks
git config commit.template .gitmessage
echo "ok: commit template and roadmap hook enabled for this clone"
