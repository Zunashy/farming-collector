# Idées de gameplay — Ferme et hack’n’slash

Ce fichier sert de réserve d’idées pour le projet. Les idées seront examinées une par une selon l’état d’avancement du jeu. Leur présence ici ne constitue pas une décision de les implémenter.

## Suivi des décisions

Statuts : **À étudier**, **Validée**, **En cours**, **Implémentée**, **Reportée**, **Rejetée**.

Avant de commencer une idée, examiner son intérêt pour la boucle de jeu, ses dépendances et le travail nécessaire. Consigner ensuite la décision et sa raison dans sa fiche. Une idée peut être modifiée avant validation.

## Idées initiales

### I01 — Revoir les actions agricoles et commerciales
- **Statut :** Implémentée
- Revoir les actions planter / récolter et arroser.
- Permettre de vendre les récoltes et d’acheter des graines selon l’argent disponible.
- Pistes d’interface : afficher la quantité achetable et proposer « acheter le maximum ».
- **Décision / raison :** Achat de graines par quantité avec prix total et « Acheter le maximum » (plafonné au budget). Messages explicites quand une action échoue (plus de graines, rien à vendre, champ non acheté). Les actions planter / arroser / récolter restent sur une seule touche (E), outil choisi automatiquement.

### I02 — Diversifier les graines
- **Statut :** À étudier
- Ajouter des graines plus coûteuses qui produisent des récoltes plus rentables.
- Compromis possibles à évaluer : croissance plus longue, besoin d’eau accru, récoltes attirant certains ennemis la nuit.
- **Décision / raison :** À renseigner.

### I03 — Ajouter la cuisine
- **Statut :** Reportée
- Cuisiner à partir des produits de la ferme.
- Usages possibles : vente, repas des employés, soins ou bonus temporaires pour le combat.
- Extension possible : recettes utilisant des ingrédients récupérés sur les monstres.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I04 — Élever des poules
- **Statut :** Reportée
- Obtenir des œufs pour la vente ou la cuisine.
- Prévoir un poulailler et sa protection pendant la nuit.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I05 — Élever des vaches
- **Statut :** Reportée
- Obtenir du lait pour la vente ou la cuisine.
- Récupérer du fumier pour fertiliser les cultures.
- Prévoir une étable et sa protection pendant la nuit.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I06 — Élever des cochons
- **Statut :** Reportée
- Permettre l’élevage de cochons ; leur rôle reste à définir.
- Pistes proposées : recherche d’ingrédients rares ou valorisation des restes de cuisine.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I07 — Transformer le blé en farine
- **Statut :** Reportée
- Donner une alternative à la vente directe du blé grâce à un moulin.
- Utiliser la farine pour préparer du pain, nourrir les employés ou vendre des produits transformés.
- Conserver un choix entre revenu immédiat et transformation ultérieure.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I08 — Recruter des employés pour la garde nocturne
- **Statut :** À étudier
- Recruter et affecter des gardes pour protéger le bétail pendant la nuit.
- Postes possibles : poulailler, étable, réserves et entrée de la ferme.
- Les gardes permettent au joueur d’intervenir sur les zones les plus menacées.
- **Décision / raison :** À renseigner.

### I09 — Gérer le sommeil et les rotations des employés
- **Statut :** Reportée
- Les employés doivent eux aussi dormir.
- Tenir compte de la fatigue liée au travail de jour et aux gardes de nuit.
- Piste de départ : quelques postes et une relève automatique pour limiter la gestion.
- **Décision / raison :** Mise de côté jusqu'à ce que la boucle jour / nuit soit testée (décision du 2026-10-31).

### I10 — Gérer une maison et l’entretien du matériel
- **Statut :** À étudier
- Prévoir une maison pour le repos et le bien-être des employés.
- Prévoir l’entretien du matériel, éventuellement dans un atelier associé.
- Améliorations possibles : lits pour la récupération, repas pour le moral, entretien des armes et outils.
- **Décision / raison :** À renseigner.

## Propositions complémentaires issues de la discussion

Ces pistes complètent les idées initiales et restent elles aussi à valider.

### I11 — Donner différents objectifs aux ennemis nocturnes
- **Statut :** À étudier
- Certains ennemis cherchent à voler les récoltes, d’autres à ouvrir les enclos ou à détruire les installations.
- Déclencher des alertes localisées pour aider le joueur à choisir où intervenir.
- **Décision / raison :** À renseigner.

### I12 — Prévoir des conséquences progressives lors des attaques
- **Statut :** Validée
- Donner au joueur le temps de réagir : alerte, panique des animaux, fuite, puis risque de perte.
- Définir les conséquences exactes lors de l’équilibrage.
- **Décision / raison :** Retenue pour le premier prototype de nuit : avertissement avant la nuit, menace sur une réserve, temps de réaction avant toute perte, pertes limitées.

### I13 — Relier la production agricole aux combats
- **Statut :** À étudier
- Boucle envisagée : cultiver → transformer → préparer les repas et les défenses → combattre → améliorer la ferme.
- La production du jour prépare la nuit ; la protection nocturne préserve la progression de la ferme.
- **Décision / raison :** À renseigner.

## Proposition de périmètre initial — à valider

Tester une première boucle avec trois cultures, des poules, un moulin et deux gardes disposant d’une rotation de sommeil. Ce périmètre est une proposition de discussion, pas un ordre de développement arrêté. Il devra être confronté aux fonctionnalités déjà présentes dans le jeu.

## Journal des décisions

| Date | Idée | Décision | Raison / conditions |
| --- | --- | --- | --- |
| 2026-10-31 | Toutes | À étudier | Enregistrement des idées ; aucune validation d’implémentation à ce stade. |
| 2026-10-31 | — | Implémentée | Collisions des clôtures : le joueur bute sur les clôtures, entre et sort par la porte ; les employés passent par la porte et le chemin. |
| 2026-10-31 | — | Implémentée | Boucle agricole vérifiée de bout en bout (planter, arroser, récolter, vendre, acheter, recruter). Corrigé : un bouton cliqué gardait le focus et Espace le réactivait ; ajout de messages à l'écran. |
| 2026-10-31 | I01 | Implémentée | Achat de graines par quantité, total affiché, « Acheter le maximum ». |
| 2026-10-31 | — | Implémentée | Menu Partie (Échap) : 3 emplacements, sauver / charger ; restaure argent, stocks, champs, cultures, employés et position du joueur. |
| 2026-10-31 | I03, I04, I05, I06, I07, I09 | Reportée | Priorité à la boucle cultiver le jour / défendre la nuit. |
| 2026-10-31 | I12 | Validée | Premier prototype de nuit à préparer ; fonctionnement à valider avant le développement. |
| 2026-10-31 | — | Implémentée | Corrections : confirmation avant d'écraser une sauvegarde ; la saisie de quantité rend la main au jeu dès qu'on appuie sur une autre touche qu'un chiffre ; le joueur ne traverse plus la boîte de vente ni les employés (qui attendent s'il leur barre le passage). |
| 2026-10-31 | — | Implémentée | Cycle jour / nuit purement décoratif (lumière seulement : jour 4 min, crépuscule, nuit 1 min 30, aube). Aucune mécanique de nuit tant que les premiers sujets ne sont pas terminés. |
