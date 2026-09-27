#!/usr/bin/env bash
# Assert the text exo-cite produces in tests/cite.typ (fork addition — see
# new_features/exo-cite.typ).
#
# Run from the package root:  bash tests/check-cite.sh

set -u
cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

fail=0

expect() { # expect <CHK-name> <expected text>
  local got
  got=$(grep -m1 "^$1:" "$tmp/cite.txt" | sed "s/^$1: //")
  if [ "$got" = "$2" ]; then
    printf 'ok    %-16s %s\n' "$1" "$got"
  else
    printf 'FAIL  %-16s expected %-28s got %s\n' "$1" "\"$2\"" "\"$got\""
    fail=1
  fi
}

if ! typst compile --root . "tests/cite.typ" "$tmp/cite.pdf" 2>"$tmp/cite.err"; then
  echo "FAIL  cite.typ did not compile:"
  cat "$tmp/cite.err"
  exit 1
fi
pdftotext "$tmp/cite.pdf" "$tmp/cite.txt"

# Forward reference: cited exercise is defined and displayed *later* in the
# document (chapter 2), from a citation written in chapter 1. Also crosses a
# page: proves counter(page).at() and the registry .final() lookup both
# resolve correctly looking forward, not just backward.
expect CHK-forward     "Exercice 2.1 (p. 2)"
# Backward reference, the common case: citing an earlier chapter, with page.
expect CHK-back-page   "Exercice 1.2 (p. 1)"
# Same, page suppressed.
expect CHK-back-nopage "Exercice 1.1"
# Unknown id: chapter number stays real (the label does resolve), but the
# exercise number and page fall back to "??", and it's no longer a link.
expect CHK-notfound    "Exercice 1.?? (p. ??)"
# prefix: none drops the exercise-label word entirely.
expect CHK-noprefix    "1.1"

exit $fail
