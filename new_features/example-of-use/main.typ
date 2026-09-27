#import "@preview/beautitled:0.3.1": *
// Relative, not @preview/exercise-bank:<version>: this example always tracks
// this fork's own lib.typ (including exo-cite, not published yet), instead
// of needing a matching version manually deployed to the local package
// cache. A document outside this repo would instead pin a real version:
// #import "@preview/exercise-bank:0.6.6": *
#import "../../lib.typ": *

#set document(
  title: "Cours de mathématiques", 
  author: "amjmeyer"
)

#set page(numbering: "1")

#set text(lang: "fr", size: 11pt)
 
#show: beautitled-init
#show: exo-auto-chapter

#beautitled-setup(
  toc-indent: 2em,
  toc-part-size: 14pt,
  style: "terrace",
  chapter-size: 18pt,
  primary-color: rgb("#2c3e50"),
  secondary-color: rgb("#7f8c8d"),
  accent-color: rgb("#2980b9"),
  enable-parts: true,
)

#exo-setup(
  exercise-label: "Exercice", 
  correction-label: "Corrigé",
  corr-display: "correction",
  corr-loc: "end-chapter",
  link-solutions: true, 
  link-style: "page",
  counter-reset: "chapter",
  number-prefix: "chapter",
  badge-style: "filled-rect", 
  badge-color: rgb("#a9a4f6"),
  correction-color: rgb("#ce1111"),
)

#beautitled-toc(
  title: "Table des matières",
  style: "anchor",
  depth: 3
  )

#pagebreak()

= Nombres

#include "chapitres/chapitre-1.typ"

= Suites

#include "chapitres/chapitre-2.typ"
