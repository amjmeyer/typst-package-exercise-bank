# exercise-bank — proposed addition: `exo-cite`

This fork adds one function, `exo-cite`, proposed for inclusion upstream.
Everything else in the package is untouched.

## What it does

`exo-select` numbers exercises as it displays them, but that number isn't
tied to a counter you can query from elsewhere. There was no way to build
"see exercise 1.2 (p. 3)" from another chapter — before or after the one
that actually displays it — without hand-rolling it per document.

`exo-cite` redoes the position-in-topic lookup `exo-select` does internally
against `exo-registry.final()` (forward/backward-safe: works whether the
cited exercise is defined before or after the citation), and reads a
chapter-like prefix from `counter(heading)` at a label placed next to the
displaying `exo-select` call. With beautitled's `enable-parts`, the prefix
takes 2 levels (part, chapter) rather than 1: the chapter number alone
restarts at 1 in each part and would otherwise let two unrelated exercises
collide under the same-looking citation (e.g. "1.2" in both part I and part
II) — caught by testing against a real `enable-parts: true` document, not
just a flat fixture.

```typst
#import "@preview/exercise-bank:0.6.6": exo-cite

#exo-setup(exercise-label: "Exercise", number-prefix: "chapter")

= Chapter 1
#exo-select(topic: "algebra") <algebra-ch1>

= Chapter 2
See #exo-cite("eq-linear-1", <algebra-ch1>, topic: "algebra") for a similar
problem.
```

An unknown id falls back to "??" instead of a wrong-looking number, and
stops being a link.

## Where to look

- [`new_features/exo-cite.typ`](new_features/exo-cite.typ) — the
  implementation, with the full parameter reference and rationale in its own
  comments and `///` doc comments.
- [`lib.typ`](lib.typ) — one import line added, in the "Utility Functions"
  section, right after `exo-count`.
- [`tests/cite.typ`](tests/cite.typ) + [`tests/check-cite.sh`](tests/check-cite.sh) —
  regression fixture (forward and backward citation across chapters,
  not-found fallback, page/prefix toggles), same convention as this
  package's other `tests/check-*.sh` scripts. Run with
  `bash tests/check-cite.sh`.
- [`new_features/example-of-use/`](new_features/example-of-use/) — a real,
  multi-chapter `beautitled` + `exercise-bank` document using `exo-cite`
  (not part of the published package — see its own README for context on
  why it was built). Compile with `typst compile new_features/example-of-use/main.typ`.

## Suggested changelog entry

```md
### [0.6.6]

#### Added
- **`exo-cite`** — cite a bank exercise from anywhere in the document
  ("Exercise 1.2 (p. 3)", clickable), by chapter number and position within
  a topic
```
