// Regression fixture for exo-cite (fork addition — see
// new_features/exo-cite.typ). No beautitled here: proves the native
// counter(heading) fallback in _chapter-at. Each check prints a CHK-<name>
// line so the expected text can be asserted with pdftotext (see
// check-cite.sh).
//
// counter(heading) only steps when heading numbering is on (Typst, not this
// fork: `format-exo-number`'s own "chapter"/"heading" prefixes have the
// exact same precondition already — see its `show-prefix` check). Real
// documents get this for free from beautitled (which keeps counter(heading)
// synchronized regardless); this fixture sets native numbering directly to
// exercise the no-beautitled path on its own.
//
// Run: typst compile --root .. tests/cite.typ out.pdf && pdftotext out.pdf -
#import "../lib.typ": *

#set page(width: 14cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.")
#exo-setup(exercise-label: "Exercice", number-prefix: "chapter", corr-loc: "after")

= Chapitre 1

#exo-define(id: "a", topic: "ch1-a", exercise: [Résoudre a.])
#exo-define(id: "b", topic: "ch1-a", exercise: [Résoudre b.])

Citation en avant : "d" n'est ni défini ni affiché avant ce point du
document, seulement plus loin, au chapitre 2 — .final() doit quand même le
trouver :

CHK-forward: #exo-cite("d", <ch2-a>, topic: "ch2-a")

#exo-select(topic: "ch1-a") <ch1-a>

#pagebreak()

= Chapitre 2

#exo-define(id: "d", topic: "ch2-a", exercise: [Résoudre d.])

#exo-select(topic: "ch2-a") <ch2-a>

Citation en arrière, avec page :

CHK-back-page: #exo-cite("b", <ch1-a>, topic: "ch1-a")

Citation en arrière, sans demande de page :

CHK-back-nopage: #exo-cite("a", <ch1-a>, topic: "ch1-a", show-page: false)

Citation vers un id introuvable dans ce topic : le chapitre reste réel, le
reste devient "??", et le résultat n'est plus un lien :

CHK-notfound: #exo-cite("zzz", <ch1-a>, topic: "ch1-a")

Appel direct sans préfixe :

CHK-noprefix: #exo-cite("a", <ch1-a>, topic: "ch1-a", show-page: false, prefix: none)
