# Git aliases (bash/zsh)

A compact reference for the git aliases and helper functions defined in `git-aliases.sh`.

Quick install

- Source the file from your shell configuration (adjust the path if needed):

```sh
# add to ~/.bashrc or ~/.zshrc
source ~/Developement/scripts/aliases/git/git-aliases.sh
```

Safety note

- Some helpers are destructive (e.g., `gclean`, `gdelete-remote-branch`). Use with care and double-check arguments before running them.

---

## Short aliases 🔧
- `gst` — `git status`
  - Example: `gst`
- `gstS` — `git status -s` (short format)
- `ga` — `git add`
- `gaa` — `git add --all`
- `gau` — `git add -u`
- `gap` — `git add -p` (patch interactively)
- `gc` — `git commit`
- `gcm` — `git commit -m "msg"`
- `gca` — `git commit -am "msg"`
- `gamend` — `git commit --amend --no-edit`
- `gco` — `git checkout`
- `gcb` — `git checkout -b <branch>` (create and switch)
- `gsw` — `git switch`
- `gsb` — `git switch -c <branch>`
- `gb` — `git branch`
- `gbr` — `git branch -vv`
- `gdel` — `git branch -D <branch>` (force delete local branch)
- `gl` — `git pull`
- `gp` — `git push`
- `gpo` — `git push origin`
- `gps` — `git push --set-upstream origin`
- `gpf` — `git push --force-with-lease`
- `gf` — `git fetch --all --prune`
- `grv` — `git remote -v`
- `gd` — `git diff`
- `gds` — `git diff --staged`
- `glog` — `git log --oneline --graph --decorate --all`
- `gll` — `git --no-pager log --stat --max-count=20`
- `gclean` — `git clean -fd` (removes untracked files and directories)
- `gstash`/`gsts`/`gsta`/`gstp` — stash commands (list, apply, pop)
- `gblame` — `git blame -w`

## Helper functions 🛠️
- `gundo()` — Undo last commit but keep changes staged
  - Usage: `gundo` (runs `git reset --soft HEAD~1`)
- `glast()` — Show the last commit details
  - Usage: `glast` (runs `git --no-pager show --stat --pretty=fuller -1`)
- `grecent([N])` — Show recent commits (default 10)
  - Usage: `grecent 5`
- `gpset()` — Push current branch to `origin` and set upstream
  - Usage: `gpset` (pushes `HEAD` and sets upstream to `origin/HEAD`)
- `gdelete-remote-branch <remote/branch>` — Delete a remote branch
  - Usage: `gdelete-remote-branch origin/my-feature`
  - Note: validates argument; prints usage when missing.
- `gclean-confirm()` — Confirm before running `git clean -fd`
  - Usage: `gclean-confirm` (prompts `Proceed? [y/N]`)
- `gri([N])` — Interactive rebase on N commits (default 3)
  - Usage: `gri 5` (runs `git rebase -i HEAD~5`)
- `gfixup <commit-ish>` — Create a fixup commit for the given commit
  - Usage: `gfixup HEAD~1` (runs `git commit --fixup <commit-ish>`)
- `galiases()` — Quick list of the most common aliases and helpers
  - Usage: `galiases` (prints an inline help block)

## Examples ✅
- Create and switch to a new branch:

```sh
gcb feature/x
```

- Add all changes and commit with a message:

```sh
gaa
gcm "Add new feature"
```

- Safely clean untracked files after confirmation:

```sh
gclean-confirm
```

- Push current branch to origin and set upstream:

```sh
gpset
```

- Delete remote branch `origin/bug-123`:

```sh
gdelete-remote-branch origin/bug-123
```

---

## Contributing / Edits
If you'd like different examples, shorter descriptions, or additional aliases, edit `git-aliases.sh` and update this README accordingly or open a PR.

---

_Last updated: 2026-01-01_
