#import "@preview/beautitled:0.3.1": *
#import "../../../lib.typ": *
#include "../exercices/chapitre1-exo.typ"

== Les nombres complexes


=== Exercices du chapitre
#exo-select(topic: "complexes") <nb-complexes-exos-pos>

Faisons des essais sur les citations d'exercices : 

+ une citation vers le même chapitre, sans page affichée ;

  *D'après #exo-cite(
    "mod-arg-1",
    <nb-complexes-exos-pos>,
    topic: "complexes",
    show-page: false,
    prefix: [l'exercice],
  )*

+ une citation vers le même chapitre, avec page affichée ;

  *D'après #exo-cite(
    "mod-arg-2",
    <nb-complexes-exos-pos>,
    topic: "complexes",
    prefix: [l'exercice],
  )*

+ une citation vers un chapitre suivant :

  *D'après #exo-cite(
    "lim-1",
    <suites-exos-pos>,
    topic: "suites",
    prefix: [l'exercice],
  ).*

+ Citation vers un id qui n'existe pas (faute de frappe volontaire, pour voir l'échec) :

  *D'après #exo-cite(
    "ex-qui-nexiste-pas",
    <suites-exos-pos>,
    topic: "suites",
    prefix: [l'exercice],
  ).*
(Le chapitre reste réel ; le numéro d'exercice et la page affichent "??", et
ce n'est plus un lien.)

#pagebreak()

=== Corrigés

#exo-print-solutions(loc: "end-chapter", title: none)
