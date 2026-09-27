#import "../../../lib.typ": exo-define

#exo-define(
  id: "ari-geo-1",
  topic: "suites",
  exercise: [
    La suite $(u_n)$ est arithmétique de raison $3$, avec $u_0 = 2$.
    Calculer $u_10$.
  ],
  correction: [
    $u_n = u_0 + n r = 2 + 3n$, donc $u_10 = 2 + 3 times 10 = 32$.
  ],
)

#exo-define(
  id: "lim-1",
  topic: "suites",
  exercise: [
    On définit $(u_n)$ par $u_0 = 1$ et $u_(n+1) = u_n / 2$. Conjecturer la
    limite de $(u_n)$.
  ],
  correction: [
    On a $u_n = (1/2)^n$, qui tend vers $0$ quand $n$ tend vers $+infinity$.
  ],
)
