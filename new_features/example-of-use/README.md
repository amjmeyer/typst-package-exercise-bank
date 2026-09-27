# beautitled + exercise-bank: citation example

A small worked example combining [`beautitled`](https://typst.app/universe/package/beautitled)
and [`exercise-bank`](https://typst.app/universe/package/exercise-bank) for a
French course document. It's what motivated `exo-cite` — see
[the fork's own README](../../README.md) and
[`new_features/exo-cite.typ`](../exo-cite.typ) — and now demonstrates the
real thing: `exo-cite` is imported from this fork's own `lib.typ` (see
`main.typ`), not hand-rolled locally.

Not part of the published package (see `exclude` in `/typst.toml`) — kept
here as a reference and a working end-to-end check.

## Layout

- `main.typ` — assembles everything: `beautitled-setup` (`enable-parts: true`,
  `style: "terrace"`) and `exo-setup` (`corr-loc: "end-chapter"`,
  `number-prefix: "chapter"`), then includes the two chapters under two parts.
- `chapitres/chapitre-1.typ`, `chapitres/chapitre-2.typ` — one file per
  chapter. Each includes its own exercise bank and displays it with
  `exo-select(topic: ...)` in an "Exercices du chapitre" section, followed by
  a "Corrigés" section on a new page. `chapitre-1.typ` also has worked
  examples of `exo-cite`: same chapter, forward reference to the next
  chapter, and the "id not found" case.
- `exercices/chapitre1-exo.typ`, `exercices/chapitre2-exo.typ` — one exercise
  bank per chapter: exercises are defined with `exo-define` (tagged with a
  `topic`), not displayed inline.

Compile with `typst compile main.typ` (tested against typst 0.15.1).

## Why this needed a package addition, not just document-level code

The goal: write `d'après #exo-cite("mod-arg-1", <pos>, topic: "complexes")`
anywhere in the document (including in an earlier chapter, or a different
file) and get a clickable "l'exercice 1.2 (p. 3)" pointing back to it — the
same idea as `beautitled-ref`, but for an exercise defined in a bank and
displayed through `exo-select`.

This wasn't built into `exercise-bank` (the existing `link-style: "page"` /
`page-ref-format` machinery links an exercise to its *own* deferred
correction, not a general "cite exercise X from anywhere" lookup): the
exercise's displayed number, when shown via `exo-select`, isn't backed by a
real Typst `counter` — it's a plain loop variable local to that call
(`display-num` in `exo-select`'s own source), and nothing about it is
written back to `exo-registry`. A first version of this citation helper
lived only in this example, reimplementing that lookup by hand; it's now
`exo-cite` in the fork itself, so the lookup logic and its edge cases (see
`new_features/exo-cite.typ`) live in one place instead of being copy-pasted
into every document that wants this.

## One gotcha that shaped the implementation

Calling a helper that itself opens `context {...}` from *inside* another
`context` block broke a plain `!= none` comparison on its return value — the
comparison always took the "found" branch, even when the lookup genuinely
returned `none`. This is why `exo-cite`'s internal lookup helper
(`_exo-topic-index` in `new_features/exo-cite.typ`) is a plain function, not
itself wrapped in `context`: the outer `context` in `exo-cite` already
provides everything `.final()` needs, and nesting a second one is what
caused the bug. Might be worth a line in the docs for anyone composing
context-returning helpers the same way — took a bit of empirical testing to
pin down.
