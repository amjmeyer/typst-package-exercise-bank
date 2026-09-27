// beautitled interop: parts, "section"/"chapter" prefixes and automatic
// per-section corrections with exo-auto-chapter (needs @local/beautitled:0.3.0)
#import "@local/beautitled:0.3.0": *
#import "../src/lib.typ": *
#set page(width: 14cm, height: auto, margin: 1.5cm)
#show: beautitled-init
#beautitled-setup(enable-parts: true)
#show: exo-auto-chapter
#exo-setup(show-qr: false, exercise-label: "Exercice", number-prefix: "section", corr-loc: "end-section")

= Partie I
== Chapitre A
#exo(exercise: [avant section : attendu 1.1], solution: [S 1.1])
=== Section A1
#exo(exercise: [attendu 1.1.1], solution: [S 1.1.1])
#exo(exercise: [attendu 1.1.2], solution: [S 1.1.2])
=== Section A2
#exo(exercise: [attendu 1.2.1], solution: [S 1.2.1])
== Chapitre B
=== Section B1
#exo-setup(number-prefix: "chapter", corr-loc: "after")
#exo(exercise: [prefix chapter : attendu 2.1])
