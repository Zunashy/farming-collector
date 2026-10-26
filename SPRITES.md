# Sprites à fournir

Pour l'instant tout est dessiné en code (rectangles colorés). Les endroits à remplacer par de vrais sprites sont marqués `# --- SPRITE` dans les scripts. Taille de tuile : **32x32**.

| Élément | Fichier / endroit | Format souhaité |
|---|---|---|
| Joueur | [scripts/player.gd](scripts/player.gd) `_draw` | Spritesheet 4 directions (bas/haut/gauche/droite), idle + marche (~4 frames), ~16x32 |
| Terre sèche | [scripts/farm_field.gd](scripts/farm_field.gd) `_draw` | 1 tuile 32x32 |
| Terre arrosée | idem | 1 tuile 32x32 (version plus sombre) |
| Blé, 4 stades | idem | 4 images 32x32 : graine, pousse, presque mûr, mûr |
| Boîte de vente | [scripts/station.gd](scripts/station.gd) / [scripts/sell_box.gd](scripts/sell_box.gd) | ~40x32 |
| Boutique de graines | [scripts/shop.gd](scripts/shop.gd) | ~48x36 (ou plus grand) |
| Herbe / sol | couleur de fond du projet | tuile 32x32 répétable |
| Icônes HUD | [scripts/hud.gd](scripts/hud.gd) | Graines, arrosoir, main, blé, pièce : 16x16 ou 24x24 |
| Item blé récolté | inventaire / HUD | 16x16 |
| (futur) Ennemis, armes, effets de coup | partie hack n slash | à définir |
