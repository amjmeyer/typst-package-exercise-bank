// ============================================================================
// FORK ADDITION — not present in upstream nathan-ed/typst-package-exercise-bank
// ============================================================================
// New in this fork: `exo-cite`, below. Candidate to propose upstream.
//
// This lives at the package root (next to lib.typ), not under src/: this
// package has no src/ directory upstream, so new_features/ follows its own
// existing flat layout rather than introducing one just for this addition.
//
// ============================================================================
// Citing a bank exercise from anywhere in the document
// ============================================================================
// exo-select assigns each displayed exercise a number, but that number is a
// plain loop variable local to that one call (`display-num` in exo-select's
// own source) — not backed by a Typst counter, and not written back to
// exo-registry (whose own `number` field is left `none` at exo-define time
// and never updated). So there is no built-in way to ask "what number did
// exercise X end up with, and where is it, and what page is it on" from
// somewhere else in the document — e.g. to write "voir l'exercice 1.2 (p. 3)"
// in a later chapter, or in an intro before the exercise is even defined.
//
// exo-cite answers that, by redoing the same position-in-topic computation
// exo-select does internally (see the note above _exo-topic-index) against
// exo-registry.final() — which is why it needs a `topic` matching whatever
// the target exo-select(topic: ...) call filtered on: the displayed number
// is relative to *that* filtered list, not to the registry as a whole. A
// target exo-select with a different kind of filter (a custom `where:`, or
// none) isn't something exo-cite can reconstruct from outside — this covers
// the common topic-filtered case, not every possible exo-select call.
//
// It still needs one thing it cannot get from the registry: *where* the
// exercise is displayed. exo-select's own per-exercise link target
// (`exb-ex-<call-base>-<n>`) only exists conditionally (link-solutions: true
// and something deferred), so it isn't a reliable general hook. Until
// exo-select records its own display location back onto the registry entry
// (a deeper change, out of scope here), the caller places one ordinary label
// next to the exo-select call that will display the exercise — the same
// label already doubles as the chapter's own anchor for the page number and
// the link target below.
//
// The chapter-like prefix reads counter(heading) (Typst's native heading
// counter) positionally (`.at(loc)`, since a citation reaches across the
// document rather than describing "here"), taking its first 1 or 2 levels —
// NOT however many levels deep pos-label actually sits (a citation might be
// placed under a "===" subsection, which must not leak into the prefix).
// With beautitled's enable-parts on, that's 2 levels, (part, chapter):
// deliberately NOT just the chapter number (beautitled's own dedicated
// chapter-counter, exercise-bank's _chapter-section() above), because with
// enable-parts chapter numbers restart at 1 in each part (LaTeX-style):
// "chapter 1" alone is ambiguous between parts, exactly the kind of
// wrong-looking-but-real citation this function exists to avoid (tested:
// two same-numbered chapters in different parts do collide if only the
// chapter is used). Without parts it's 1 level, the chapter number alone,
// same as _chapter-section(). Same "pad to a fixed depth" technique
// format-exo-number's own "heading" prefix mode already uses, for the same
// reason: a missing level must not silently shift the ones that follow.
//
// This needs beautitled to keep counter(heading) synchronized, which it
// does unconditionally (see its own "Interoperability" docs) -- or, without
// beautitled, native heading numbering turned on (`#set heading(numbering:
// "1.")`), since Typst itself only steps counter(heading) when numbering is
// on. Same precondition `number-prefix: "chapter"` / `"heading"` already
// have.
//
// This file is imported *by* lib.typ, so it cannot import lib.typ back
// (that would be circular) to reach exo-registry / exo-config / beautitled's
// own config state. Same fix _beautitled-parts() above already relies on:
// a Typst state is identified by its name string, not by the variable
// binding, so redeclaring it here with the same name reaches the exact
// same shared state lib.typ's own exo-registry / exo-config, and beautitled's
// own enable-parts setting, point to.
#let exo-registry = state("exo-registry", ())
#let exo-config = state("exo-config", (:))

#let _number-prefix-at(loc) = {
  let enable-parts = state("beautitled-config", (enable-parts: false)).get().at("enable-parts", default: false)
  let depth = if enable-parts { 2 } else { 1 }
  let levels = counter(heading).at(loc)
  let prefix = range(depth).map(i => levels.at(i, default: 0))
  if prefix.all(l => l == 0) { none } else { prefix }
}

// 1-based position of `id` within `topic` (or the whole registry when
// `topic` is `none`), or `none` if no such id exists there. Uses `.final()`
// rather than `.get()` so the lookup is independent of whether the cited
// exercise is defined before or after the citation (tested both directions).
#let _exo-topic-index(id, topic) = {
  let registry = exo-registry.final()
  let filtered = if topic == none {
    registry
  } else {
    registry.filter(e => e.metadata.at("topic", default: none) == topic)
  }
  let idx = none
  for (i, e) in filtered.enumerate() {
    if e.id == id { idx = i + 1 }
  }
  idx
}

/// Cite a bank exercise from anywhere in the document: "Exercise 1.2 (p. 3)",
/// clickable, linking back to `pos-label`. With beautitled's enable-parts,
/// that's "Exercise 2.1.3" (part 2, chapter 1) — see the note above
/// `_number-prefix-at` for why the part is included.
///
/// The chapter-like prefix needs either beautitled (which keeps
/// `counter(heading)` synchronized unconditionally) or native heading
/// numbering turned on (`#set heading(numbering: "1.")`) — same
/// precondition `number-prefix: "chapter"` / `"heading"` already have via
/// `counter(heading)`, which Typst itself only steps when numbering is on.
/// Without either, the prefix is silently omitted (matching
/// `format-exo-number`'s own `show-prefix` behavior), not an error.
///
/// - `id`: the exercise's id (as passed to, or auto-generated by, `exo-define`).
/// - `pos-label`: a label placed next to the `exo-select` call that displays
///   this exercise (see the module-level comment above for why this is still
///   needed). Read at that label: the chapter-like prefix and the page
///   number, and it is the citation's link target.
/// - `topic`: must match the `topic:` the target `exo-select` call filtered
///   on, since the exercise's displayed number is its position within that
///   filtered list, not within the whole registry. Leave as `none` only if
///   the target `exo-select` shows the whole registry unfiltered.
/// - `show-page`: append "(p. N)" (default: `true`).
/// - `prefix`: content shown before the number, or `none` for none. `auto`
///   (the default) reuses this document's own configured `exercise-label`
///   (`exo-setup(exercise-label: ...)`), the same word `exo-select` itself
///   uses.
/// - `page-prefix`: text before the page number (default: `"p. "`).
///
/// If `id` isn't found under `topic`, the chapter stays real (`pos-label`
/// does exist) but the exercise number and page fall back to "??", and the
/// result is plain text rather than a link — a wrong-looking but real number
/// would be worse than an honest placeholder.
///
/// Example:
/// ```typst
/// #exo-setup(exercise-label: "Exercice", number-prefix: "chapter")
///
/// = Chapitre 1
/// #exo-select(topic: "algebra") <algebra-ch1>
///
/// = Chapitre 2
/// Voir #exo-cite("eq-lineaire-1", <algebra-ch1>, topic: "algebra").
/// ```
#let exo-cite(
  id,
  pos-label,
  topic: none,
  show-page: true,
  prefix: auto,
  page-prefix: "p. ",
) = context {
  let idx = _exo-topic-index(id, topic)
  let found = idx != none
  let n = if found { [#idx] } else { [??] }

  let sep = exo-config.get().at("number-separator", default: ".")
  let prefix-levels = _number-prefix-at(pos-label)
  let number = if prefix-levels != none {
    [#prefix-levels.map(str).join(sep)#sep#n]
  } else {
    n
  }

  let prefix-content = if prefix == auto {
    exo-config.get().at("exercise-label", default: none)
  } else {
    prefix
  }
  let body = if prefix-content in (none, []) { number } else { [#prefix-content #number] }

  let page-text = if show-page {
    if found { [ (#page-prefix#counter(page).at(pos-label).first())] } else { [ (#page-prefix??)] }
  } else { [] }

  if found { link(pos-label)[#body#page-text] } else { [#body#page-text] }
}
