#!/usr/bin/env bash
# Read-only snapshot of a repo and all its worktrees, for the sync skill.
# Usage: inventory.sh [path-inside-repo]
set -euo pipefail
cd "${1:-.}"
root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "ERROR: not a git repo: $(pwd)"; exit 1; }
cd "$root"
remote=$(git remote | head -1 || true)
[ -n "$remote" ] && git fetch -q "$remote" 2>/dev/null || true

main=""
if [ -n "$remote" ]; then
  main=$(git symbolic-ref -q --short "refs/remotes/$remote/HEAD" 2>/dev/null | sed "s#^$remote/##" || true)
fi
for b in main master; do [ -z "$main" ] && git show-ref -q --verify "refs/heads/$b" && main=$b; done
main=${main:-main}

# Integration mode: per-repo override file, else infer from history.
mode=""
cfg="${SYNC_REPOS_CONF:-$HOME/.config/sync/repos.conf}"
common=$(cd "$(git rev-parse --git-common-dir)/.." && pwd)
if [ -f "$cfg" ]; then mode=$(awk -v p="$common" '$1==p{print $2}' "$cfg" | tail -1); fi
if [ -z "$mode" ]; then
  ref="$main"; [ -n "$remote" ] && git show-ref -q --verify "refs/remotes/$remote/$main" && ref="$remote/$main"
  prs=$(git log "$ref" -60 --format=%s 2>/dev/null | grep -cE '\(#[0-9]+\)$|^Merge pull request #' || true)
  if [ "${prs:-0}" -ge 3 ]; then mode=pr; else mode=direct; fi
  mode_src=inferred
else
  mode_src=repos.conf
fi

echo "repo:        $common"
echo "remote:      ${remote:-none} $( [ -n "$remote" ] && git remote get-url "$remote")"
echo "main branch: $main"
echo "mode:        $mode ($mode_src)"
if [ -n "$remote" ] && git show-ref -q --verify "refs/remotes/$remote/$main"; then
  read -r behind ahead < <(git rev-list --left-right --count "$remote/$main...$main" 2>/dev/null || echo "? ?")
  echo "local $main vs $remote/$main: ahead $ahead, behind $behind"
fi
echo
echo "worktrees:"
git worktree list --porcelain | awk '/^worktree /{print substr($0,10)}' | while read -r wt; do
  [ -d "$wt" ] || { echo "- $wt  [MISSING ON DISK]"; continue; }
  br=$(git -C "$wt" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
  mod=$(git -C "$wt" status --porcelain --untracked-files=no | wc -l | tr -d ' ')
  unt=$(git -C "$wt" ls-files --others --exclude-standard | wc -l | tr -d ' ')
  state=""
  [ -e "$(git -C "$wt" rev-parse --git-dir)/MERGE_HEAD" ] && state=" MERGE-IN-PROGRESS"
  [ -d "$(git -C "$wt" rev-parse --git-dir)/rebase-merge" ] && state=" REBASE-IN-PROGRESS"
  if [ "$br" = "$main" ]; then rel="(main checkout)"; else
    read -r b a < <(git rev-list --left-right --count "$main...$br" 2>/dev/null || echo "? ?")
    rel="ahead of $main: $a, behind: $b"
  fi
  echo "- $wt"
  echo "    branch $br | modified $mod | untracked $unt | $rel$state"
done
