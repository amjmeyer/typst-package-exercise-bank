#import "../../../lib.typ": exo-define

#exo-define(
  id: "alg-1",
  topic: "complexes",
  exercise: [Écrire le nombre complexe $z = (1+i)^2$ sous forme algébrique.],
  correction: [
    $z = (1+i)^2 = 1 + 2i + i^2 = 1 + 2i - 1 = 2i$.
  ],
)

#exo-define(
  id: "mod-arg-1",
  topic: "complexes",
  exercise: [Déterminer le module et un argument de $z = 1 + i$.],
  correction: [
    $|z| = sqrt(1^2 + 1^2) = sqrt(2)$. Comme $"Re"(z) = "Im"(z) > 0$, un
    argument de $z$ est $theta = pi/4$.
  ],
)


#exo-define(
  id: "mod-arg-2",
  topic: "complexes",
  exercise: [Déterminer le module et un argument de $z = 1 - i$.],
  correction: [
    $|z| = sqrt(1^2 + 1^2) = sqrt(2)$. Comme $"Re"(z) = "Im"(z) < 0$, un
    argument de $z$ est $theta = pi/4$.
  ],
)

