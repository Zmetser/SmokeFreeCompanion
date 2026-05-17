---
name: memory-sync
description: After significant code changes or phase completions, audit Claude memory and project docs for staleness and update both. Use when a feature ships, a refactor lands, conventions change, or a planning doc in docs/_zee/ becomes outdated.
---

# Memory Sync

Audit auto-memory and project docs after meaningful changes. Delete what's stale, capture what's new, commit the sync on its own.

**Run after:** a feature shipped, a refactor across 3+ files, a new convention worth keeping, or a planning doc in `docs/_zee/` that no longer matches reality. **Skip for:** single-file fixes, typos, WIP.

## Checklist

```
- [ ] Review changes: git log --oneline -20, git diff --name-only HEAD~10..HEAD
- [ ] Audit each memory file: still true? Update, delete, or move to CLAUDE.md if it's architecture in disguise.
- [ ] If a memory was deleted, remove its line from MEMORY.md too.
- [ ] CLAUDE.md spot-check: do its make targets, file paths, device list, and architecture still match the repo?
- [ ] docs/_zee/ plans: mark shipped items done, drop stale "next up" entries.
- [ ] Non-obvious gotcha learned this cycle? One paragraph in docs/learnings.md.
- [ ] Commit memory/doc updates separately from feature work.
```

## Where each change lands

| Change | Update |
|---|---|
| New view / module / entry point | `CLAUDE.md` Architecture |
| Build / test workflow | `CLAUDE.md` Build, `docs/setup.md` |
| Device support, API level, languages | `CLAUDE.md` Project, `CHANGELOG.md`, `README.md` |
| Conventions (naming, commits, errors) | `CLAUDE.md` |
| Feature shipped from a `_zee/` plan | mark/archive the plan, `CHANGELOG.md` |
| Debugging gotcha | `docs/learnings.md` |
| User correction worth keeping | auto-memory (feedback type) |
