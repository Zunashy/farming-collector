# Sprites de ferme

17 assets PNG générés avec l’outil imagegen intégré, puis réduits sans lissage aux dimensions demandées. Sources haute résolution dans `sources/`. Aperçu : `preview.png`.

| Fichier | Dimensions |
|---|---|
| player.png | 64 × 128 |
| employee.png | 64 × 128 |
| soil_dry.png | 32 × 32 |
| soil_wet.png | 32 × 32 |
| grass.png | 32 × 32 |
| wheat_0.png | 32 × 32 |
| wheat_1.png | 32 × 32 |
| wheat_2.png | 32 × 32 |
| wheat_3.png | 32 × 32 |
| sell_box.png | 40 × 32 |
| icon_seeds.png | 16 × 16 |
| icon_can.png | 16 × 16 |
| icon_hand.png | 16 × 16 |
| icon_wheat.png | 16 × 16 |
| icon_coin.png | 16 × 16 |
| icon_market.png | 24 × 24 |
| field_for_sale.png | 128 × 128 |

## Personnages

Grille 4 colonnes × 4 lignes, cellules 16 × 32. Lignes : bas, haut, gauche, droite. Colonnes demandées : repos, pas gauche, transition, pas droit. Vérifier le cadrage et les boucles dans le moteur avant intégration définitive. Employé fourni en une seule apparence recolorable.

## Import Godot

Filtrage Nearest pour préserver les pixels. Cultures et objets en transparence. Sols et herbe opaques. Tester les raccords de l’herbe et les animations en situation. Aucun script de jeu modifié.

## Prompts de génération

Consigne commune : pixel art de ferme chaleureux, palette douce, contours lisibles, perspective RPG du dessus, pixels nets, sans dégradés ni lissage ; fond transparent sauf tuiles de sol opaques. Rendu agrandi pour réduction aux dimensions cibles.

- **player.png**, 64 × 128 : spritesheet farmer straw hat blue overalls: EXACT 4 columns and 4 rows equal cells; each cell 16x32 logical pixels, rows facing down up left right. Columns idle, step left, passing, step right. Transparent space, consistent position feet baseline every cell.
- **employee.png**, 64 × 128 : spritesheet farm employee beige shirt neutral gray overalls recolorable: EXACT 4 columns and 4 rows equal cells; cells 16x32 logical pixels, rows down up left right; columns idle, step left, passing, step right; consistent feet baseline.
- **soil_dry.png**, 32 × 32 : full square seamless dry tilled brown soil tile, horizontal furrows, fills entire square.
- **soil_wet.png**, 32 × 32 : full square seamless wet dark brown tilled soil tile horizontal furrows fills entire square.
- **grass.png**, 32 × 32 : full square seamless soft green grass ground tile, sparse subtle grass pixels, no border fills entire square.
- **wheat_0.png**, 32 × 32 : seed on soil tiny grains isolated crop sprite transparent background no ground square.
- **wheat_1.png**, 32 × 32 : small green sprouts isolated crop sprite transparent background no ground square.
- **wheat_2.png**, 32 × 32 : almost ripe wheat green and gold isolated crop sprite transparent background no ground square.
- **wheat_3.png**, 32 × 32 : ripe golden wheat cluster isolated crop sprite transparent background no ground square.
- **sell_box.png**, 40 × 32 : wooden farm shipping crate with open top and small wheat emblem, top down three quarter view.
- **icon_seeds.png**, 16 × 16 : tiny seed pouch icon.
- **icon_can.png**, 16 × 16 : tiny teal watering can icon.
- **icon_hand.png**, 16 × 16 : tiny hand interaction icon.
- **icon_wheat.png**, 16 × 16 : tiny harvested golden wheat sheaf icon.
- **icon_coin.png**, 16 × 16 : tiny gold coin icon.
- **icon_market.png**, 24 × 24 : tiny market stall icon red cream awning.
- **field_for_sale.png**, 128 × 128 : square grassy unpurchased farm plot with low wood corner fences and central wooden sign with exact French text À VENDRE. Entire square 128x128 logical pixels. Top down farm game view.

