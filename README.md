# dotfiles

Version-controlled personal configuration, symlinked into place from `$HOME`.

## Layout

```
claude/
  skills/
    conclude-session/   # personal Claude Code skill → ~/.claude/skills/conclude-session
```

## Install (recreate symlinks on a new machine)

```bash
./install.sh
```

This symlinks each tracked item back into `$HOME`. The real files live here; `$HOME` only holds links, so edits are version-controlled automatically.

## Conventions

- `~/.claude/` itself is **not** a git repo (it holds transcripts, session data, caches). Only specific config (skills, settings) is tracked here and symlinked in.
- Add a new tracked item: move the real file into `claude/...`, symlink it back into `~/.claude/...`, then add a line to `install.sh`.
