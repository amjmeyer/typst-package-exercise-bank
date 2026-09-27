// Test suite for the 0.7.0 features: titles, worked examples, header gaps,
// literal / multi-level number prefixes
//   typst compile --root .. features-0.7.typ features-0.7-{p}.png --format png

#import "../src/lib.typ": *

#set page(width: 16cm, height: 22cm, margin: (left: 2.5cm, rest: 1.2cm))
#set text(size: 10pt, lang: "fr")
#exo-setup(show-qr: false, label-font-size: 10pt, exercise-label: "Exercice")

// ============================================================
// Page 1: titles on every style
// ============================================================
= Titres

#for style in ("box", "circled", "pill", "margin", "border-accent", "underline", "rounded-box", "header-card") {
  exo-setup(badge-style: style)
  exo(
    title: [Calculer une longueur avec le théorème de Pythagore],
    exercise: [Style *#raw(style)*. Calculer $A C$ sachant que $A B = 3$ et $B C = 4$.],
  )
}

#exo-setup(badge-style: "box", badge-position: "above")
#exo(title: [Badge au-dessus], exercise: [Le titre suit le badge sur la ligne d'en-tête.])
#exo-setup(badge-position: "margin")

#pagebreak()

// ============================================================
// Page 2: worked examples
// ============================================================
= Exercices corrigés

#exo-setup(display: "ex", badge-style: "underline")
#exo(
  title: [Exemple corrigé],
  worked: true,
  exercise: [Simplifier $e^3 times e^4$.],
  solution: [$e^7$],
)
#exo(
  exercise: [Simplifier $e^5 times e^(-2)$ (solution cachée : display "ex").],
  solution: [$e^3$],
)

#exo-setup(display: "both", corr-display: "solution", corr-loc: "end-section", title-in-solutions: true)
#exo(
  title: [Corrigé, correction seulement],
  worked: true,
  exercise: [Correction affichée malgré corr-display "solution" et corr-loc "end-section".],
  correction: [Correction détaillée.],
)
#exo(title: [Différé], exercise: [Solution renvoyée en fin de section.], solution: [Plus loin.])
#exo-section-end()
#exo-setup(corr-loc: "after", title-in-solutions: false)

#pagebreak()

// ============================================================
// Page 3: header gaps
// ============================================================
= Espacements d'en-tête

#exo-setup(badge-style: "underline")
#exo(exercise: [underline, auto (défaut)])
#exo-setup(header-rule-gap: 0.25em, header-body-gap: 0.5em)
#exo(exercise: [underline, compact (0.25em / 0.5em)])
#exo-setup(badge-style: "border-accent")
#exo(exercise: [border-accent, compact])
#exo-setup(badge-style: "rounded-box")
#exo(exercise: [rounded-box, compact])
#exo-setup(badge-style: "header-card")
#exo(exercise: [header-card, compact])
#exo-setup(badge-style: "box", badge-position: "above")
#exo(exercise: [box above, compact])
#exo-setup(badge-position: "margin", header-rule-gap: auto, header-body-gap: auto)

#pagebreak()

// ============================================================
// Page 4: number prefixes
// ============================================================
= Préfixes

#exo-setup(badge-style: "box", number-prefix: 3)
#exo(exercise: [Série 3 : doit afficher 3.1])
#exo(exercise: [3.2])
#exo-setup(number-prefix: "A", number-separator: "-")
#exo(exercise: [A-1 (compteur remis à zéro)])
#exo-setup(number-prefix: "heading", number-prefix-depth: 2, number-separator: ".")
#set heading(numbering: "1.1")
= Chapitre numéroté
== Sous-section
#exo-reset-counter()
#exo(exercise: [Doit afficher 1.1.1])
#exo(exercise: [1.1.2])
