# Sprites

Les sprites sont dans [assets/sprites/](assets/sprites/) (voir les README du dossier, `MAP.md`, `TASKS.md` et les aperçus). Taille de tuile : **32x32**. Filtrage Nearest réglé dans `project.godot`. Le monde est affiché avec un zoom x2 (caméra du joueur).

| Élément | Fichier | Utilisé dans |
|---|---|---|
| Joueur | `player.png` (spritesheet 4x4, cellules 16x32, affichée en x1,5) | [scripts/player.gd](scripts/player.gd) via [scripts/character_sprite.gd](scripts/character_sprite.gd) |
| Employé | `employee.png` (même format, teinte par employé) | [scripts/employee.gd](scripts/employee.gd) |
| Terre sèche / arrosée | `soil_dry.png`, `soil_wet.png` | [scripts/farm_field.gd](scripts/farm_field.gd) |
| Blé, 4 stades | `wheat_0.png` à `wheat_3.png` | idem |
| Champ non acheté | `field_for_sale.png` (128x128) | idem |
| Boîte de vente | `sell_box.png` | [scripts/sell_box.gd](scripts/sell_box.gd) / [scripts/station.gd](scripts/station.gd) |
| Herbe, fleurs | `grass.png`, `flowers_white.png`, `flowers_mixed.png` | [scripts/world_map.gd](scripts/world_map.gd) |
| Chemins de terre | `dirt_plain.png`, `dirt_pebbles.png` | idem |
| Clôtures | `fence_horizontal.png`, `fence_vertical.png`, `fence_corner_nw/ne/sw/se.png`, `fence_gate.png` | idem |
| Icônes de tâches (24x24) | `task_rest.png`, `task_plant.png`, `task_water.png`, `task_harvest.png`, `task_sell.png` | [scripts/employee.gd](scripts/employee.gd) (`TASK_ICONS`), [scripts/employee_menu.gd](scripts/employee_menu.gd), [scripts/employee_list.gd](scripts/employee_list.gd) |
| Icônes HUD | `icon_coin.png`, `icon_seeds.png`, `icon_wheat.png`, `icon_market.png` | [scripts/hud.gd](scripts/hud.gd), [scripts/market_menu.gd](scripts/market_menu.gd) |
| Icônes d'action | `icon_seeds.png`, `icon_can.png`, `icon_hand.png` | [scripts/farm_field.gd](scripts/farm_field.gd) (action indiquée sur la case visée) |

`fence_corner.png` n'est pas utilisé : les 4 angles `fence_corner_nw/ne/sw/se.png` le remplacent.

## Spritesheets des personnages

Lignes : bas, haut, gauche, droite. Colonnes : repos, pas gauche, transition, pas droit. Cycle de marche : colonnes 1, 2, 3, 2. Les pieds sont alignés sur le bas de chaque cellule (la feuille du joueur a été recalée ; l'original est dans `assets/sprites/sources/player_original_64x128.png`).

Les personnages sont agrandis de x1,5 (`CharacterSprite.SPRITE_SCALE`) : avec le zoom x2, chaque pixel de sprite fait exactement 3 pixels d'écran.

## Disposition de la carte

Tout est défini dans [scripts/world_map.gd](scripts/world_map.gd), en cases de 32 px : carte de 28 x 16 cases, trois enclos de 6x6 cases (4x4 de champ + clôture), une route de terre avec une jonction devant chaque porte, un sentier vers la boîte de vente. Le semis de fleurs est fixe (même carte à chaque lancement).

## Sauvegarde

Trois emplacements dans `user://saves/` (`slot_1.json` à `slot_3.json`), gérés par [scripts/save_game.gd](scripts/save_game.gd). `Main.save_game(slot)` et `Main.load_game(slot)` (slot de 0 à 2) existent mais rien ne les appelle encore : le jeu repart de zéro à chaque lancement.

## À fournir plus tard

- Ennemis, armes, effets de coup (partie hack n slash).
- Animation de travail des employés (planter, arroser, récolter).
