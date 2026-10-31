class_name WorldMap
extends Node2D
## Décor de la carte : herbe fleurie, chemins de terre, clôtures autour des champs.
## Toute la disposition (en cases de 32 px) est définie ici ; Main s'en sert pour placer le reste.

const TILE := 32
const COLS := 28
const ROWS := 16
const SIZE := Vector2(COLS * TILE, ROWS * TILE)

const FIELD_BLOCK_COLS: Array[int] = [6, 13, 20] ## colonne du coin haut gauche de chaque enclos (6x6 cases)
const BLOCK_ROW := 2 ## ligne du haut des enclos
const BLOCK_SIZE := 6 ## 4x4 cases de champ + 1 case de clôture tout autour
const GATE_OFFSET := 2 ## colonne de la porte, en partant de la gauche de l'enclos
const ROAD_ROW := 9
const SELL_TILE := Vector2i(3, 6)

const GRASS := preload("res://assets/pack_v2/tiles_grass.png")
const PATH_TILES := preload("res://assets/pack_v2/tiles_path.png")
const FENCE_BACK := preload("res://assets/pack_v2/fence_v3_back.png")
const FENCE_FRONT := preload("res://assets/pack_v2/fence_v3_front.png")
const FENCE_FRONT_LAYER := preload("res://scripts/fence_front.gd")
const FENCE_BACK_BASE := 40 ## bas de la traverse du haut, dans fence_enclosure_back.png
const FENCE_FRONT_BASE := 176 ## bas de la traverse du bas, dans fence_enclosure_front.png
## Emprise au sol de la clôture dans l'enclos (192 x 192), là où se trouvent les pieds des poteaux.
const FENCE_LEFT := 9
const FENCE_RIGHT := 184
const FENCE_SIDE := 18 ## épaisseur des côtés
const FENCE_DEPTH := 12 ## profondeur des traverses haut et bas, au-dessus de leur base
## Passage libre de la porte, entre les bords intérieurs de ses poteaux (x dans l'enclos) :
## la porte ouverte (fence_gate_open.png) est posée à x = 64, poteaux de 0 à 11 et à partir de 33.
const GATE_LEFT := 75
const GATE_RIGHT := 97


## Coin haut gauche des 4x4 cases du champ.
static func field_position(index: int) -> Vector2:
	return Vector2((FIELD_BLOCK_COLS[index] + 1) * TILE, (BLOCK_ROW + 1) * TILE)


## Point sur le chemin, juste devant la porte de l'enclos (dans l'axe du passage).
static func gate_front(index: int) -> Vector2:
	var x := FIELD_BLOCK_COLS[index] * TILE + (GATE_LEFT + GATE_RIGHT) / 2.0
	return Vector2(x, (BLOCK_ROW + BLOCK_SIZE + 1) * TILE + TILE / 2.0)


## Point dans le champ, juste derrière la porte (rangée du bas).
static func gate_inside(index: int) -> Vector2:
	return Vector2(gate_front(index).x, (BLOCK_ROW + BLOCK_SIZE - 2) * TILE + TILE / 2.0)


## Index de l'enclos dont l'intérieur (dans la clôture) contient pos, ou -1.
static func enclosure_at(pos: Vector2) -> int:
	for i in FIELD_BLOCK_COLS.size():
		var origin := Vector2(FIELD_BLOCK_COLS[i] * TILE, BLOCK_ROW * TILE)
		var inner := Rect2(origin + Vector2(FENCE_LEFT + FENCE_SIDE, FENCE_BACK_BASE),
				Vector2(FENCE_RIGHT - FENCE_LEFT - 2 * FENCE_SIDE, FENCE_FRONT_BASE - FENCE_DEPTH - FENCE_BACK_BASE))
		if inner.has_point(pos):
			return i
	return -1


## Index de l'enclos dont l'emprise (clôture comprise, ou l'allée de la porte jusqu'au chemin) contient pos, ou -1.
static func _enclosure_footprint_at(pos: Vector2) -> int:
	for i in FIELD_BLOCK_COLS.size():
		var origin := Vector2(FIELD_BLOCK_COLS[i] * TILE, BLOCK_ROW * TILE)
		if Rect2(origin, Vector2(BLOCK_SIZE * TILE, FENCE_FRONT_BASE + 4)).has_point(pos):
			return i
		var front := gate_front(i)
		if absf(pos.x - front.x) <= 1.0 and pos.y > origin.y and pos.y < front.y - 1.0:
			return i
	return -1


## Prochain point vers lequel marcher pour aller de from à to sans traverser de clôture :
## on entre et on sort des enclos par la porte, et on rejoint une porte par le chemin du bas.
static func next_waypoint(from: Vector2, to: Vector2) -> Vector2:
	var a := enclosure_at(from)
	var b := enclosure_at(to)
	if a != -1 and a == b:
		return to
	if a != -1: # sortir : aller jusqu'à la porte, puis descendre droit dessous
		var inside := gate_inside(a)
		return inside if absf(from.x - inside.x) > 1.0 else gate_front(a)
	var passage := _enclosure_footprint_at(from)
	if passage != -1: # dans l'ouverture de la porte : la franchir tout droit
		return gate_inside(passage) if passage == b else gate_front(passage)
	if b != -1 and b != a:
		var front := gate_front(b)
		if absf(from.x - front.x) <= 1.0 and from.y <= front.y + 1.0:
			return gate_inside(b)
		if from.y < front.y - 1.0: # d'abord descendre jusqu'au chemin, sous les enclos
			return Vector2(from.x, front.y)
		return front
	return to


static func sell_box_position() -> Vector2:
	return Vector2(SELL_TILE) * TILE + Vector2(TILE, TILE) / 2.0


func _draw() -> void:
	var dirt := _dirt_tiles()
	for y in ROWS:
		for x in COLS:
			var pos := Vector2(x, y) * TILE
			draw_texture_rect_region(GRASS, Rect2(pos, Vector2(TILE, TILE)), Rect2((_noise(x, y) % 4) * TILE, 0, TILE, TILE))
			# Les couleurs du pack sont affichées directement, sans voile gris-vert.
	_draw_meadow_details(dirt)
	# Même terre sur tout le réseau, avec des coins arrondis aux bords libres.
	for cell: Vector2i in dirt:
		var style := StyleBoxFlat.new()
		style.bg_color = Color(0.65, 0.46, 0.27)
		var north := dirt.has(cell + Vector2i.UP)
		var south := dirt.has(cell + Vector2i.DOWN)
		var west := dirt.has(cell + Vector2i.LEFT)
		var east := dirt.has(cell + Vector2i.RIGHT)
		style.corner_radius_top_left = 8 if not north and not west else 0
		style.corner_radius_top_right = 8 if not north and not east else 0
		style.corner_radius_bottom_left = 8 if not south and not west else 0
		style.corner_radius_bottom_right = 8 if not south and not east else 0
		var rect := Rect2(Vector2(cell) * TILE, Vector2(TILE, TILE))
		var mask := (1 if north else 0) + (2 if east else 0) + (4 if south else 0) + (8 if west else 0)
		var source := Vector2i(mask % 4, mask / 4) * TILE
		if mask == 15:
			source = Vector2i(_noise(cell.x, cell.y) % 4, 4) * TILE
		draw_texture_rect_region(PATH_TILES, rect, Rect2(Vector2(source), Vector2(TILE, TILE)))
		# Des grains distribués jusque sur les raccords, sans carré de texture en retrait.
		var rng := RandomNumberGenerator.new()
		rng.seed = int(cell.x) * 73856093 + int(cell.y) * 19349663
		for i in 65:
			var p := Vector2(rng.randi_range(0, 31), rng.randi_range(0, 31))
			# Respecter les coins arrondis de la silhouette du chemin.
			var corner := Vector2(8 if p.x < 16 else 24, 8 if p.y < 16 else 24)
			var radius := style.corner_radius_top_left if p.x < 16 else style.corner_radius_top_right
			if p.y >= 16:
				radius = style.corner_radius_bottom_left if p.x < 16 else style.corner_radius_bottom_right
			if radius > 0 and absf(p.x - corner.x) > 0 and absf(p.y - corner.y) > 0:
				var in_corner := (p.x < 8 or p.x > 24) and (p.y < 8 or p.y > 24)
				if in_corner and p.distance_to(corner) > 7:
					continue
			var color := Color(0.81, 0.63, 0.40, 0.35) if i % 3 != 0 else Color(0.39, 0.28, 0.18, 0.24)
			draw_rect(Rect2(rect.position + p, Vector2(2 if i % 7 == 0 else 1, 1)), color)
			if i % 23 == 0:
				draw_rect(Rect2(rect.position + p, Vector2(2, 2)), Color(0.72, 0.64, 0.48, 0.55))


## Petites touches dans une distribution continue, indépendante de la grille des tuiles.
func _draw_meadow_details(dirt: Dictionary) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 41027
	for i in 2800:
		var p := Vector2(rng.randi_range(2, int(SIZE.x) - 4), rng.randi_range(4, int(SIZE.y) - 4))
		var cell := Vector2i(floori(p.x / TILE), floori(p.y / TILE))
		if dirt.has(cell):
			continue
		# Les bouquets se regroupent en zones, plutôt qu'en cases de couleurs.
		var patch := sin(p.x * 0.037 + sin(p.y * 0.023) * 2.0) * cos(p.y * 0.031)
		var shade := Color(0.32, 0.44, 0.18, 0.42) if patch > 0 else Color(0.66, 0.68, 0.31, 0.40)
		draw_rect(Rect2(p, Vector2(2, 1)), shade)
		if i % 7 == 0 and patch > 0.1:
			draw_line(p, p + Vector2(-1, -3), Color(0.29, 0.43, 0.16, 0.7))
			draw_line(p + Vector2(1, 0), p + Vector2(2, -4), Color(0.57, 0.65, 0.26, 0.8))
		if i % 29 == 0 and patch > 0.15:
			var petal := Color(0.94, 0.88, 0.66) if i % 2 == 0 else Color(0.87, 0.67, 0.38)
			draw_rect(Rect2(p + Vector2(-1, -2), Vector2(3, 1)), petal)
			draw_rect(Rect2(p + Vector2(0, -3), Vector2(1, 3)), petal)
			draw_rect(Rect2(p + Vector2(0, -2), Vector2.ONE), Color(0.85, 0.65, 0.22))


## Cases de chemin : la route, le sentier de la boîte de vente et un passage sous chaque porte.
func _dirt_tiles() -> Dictionary:
	var tiles := {}
	var last_gate_col: int = FIELD_BLOCK_COLS[-1] + GATE_OFFSET
	for x in range(SELL_TILE.x, last_gate_col + 2):
		tiles[Vector2i(x, ROAD_ROW)] = true
	for y in range(SELL_TILE.y + 1, ROAD_ROW):
		tiles[Vector2i(SELL_TILE.x, y)] = true
	for c0 in FIELD_BLOCK_COLS:
		# De la case de la porte (dessinée par-dessus) jusqu'à la route.
		tiles[Vector2i(c0 + GATE_OFFSET, BLOCK_ROW + BLOCK_SIZE - 1)] = true
		tiles[Vector2i(c0 + GATE_OFFSET, BLOCK_ROW + BLOCK_SIZE)] = true
	return tiles


## Deux couches parfaitement alignées, ajoutées après le sol et les cultures.
## parent trie ses enfants en profondeur : chaque couche est rangée à la base de sa traverse
## (FENCE_BACK_BASE, FENCE_FRONT_BASE), pour que les personnages passent devant ou derrière.
static func add_fence_layers(parent: Node2D) -> void:
	for c0 in FIELD_BLOCK_COLS:
		var origin := Vector2(c0 * TILE, BLOCK_ROW * TILE)
		var sprite := Sprite2D.new()
		sprite.texture = FENCE_BACK
		sprite.centered = false
		sprite.position = Vector2(0, -FENCE_BACK_BASE)
		parent.add_child(_sort_anchor(origin + Vector2(0, FENCE_BACK_BASE), sprite))
		var front := Node2D.new()
		front.set_script(FENCE_FRONT_LAYER)
		front.position = Vector2(0, -FENCE_FRONT_BASE)
		parent.add_child(_sort_anchor(origin + Vector2(0, FENCE_FRONT_BASE), front))
		parent.add_child(_fence_body(origin))


## Corps physique de la clôture d'un enclos : trois côtés pleins et le bas ouvert devant la porte.
static func _fence_body(origin: Vector2) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = origin
	var top := FENCE_BACK_BASE - FENCE_DEPTH
	var bottom := FENCE_FRONT_BASE - FENCE_DEPTH
	var gap_left := GATE_LEFT
	var gap_right := GATE_RIGHT
	var rects: Array[Rect2] = [
		Rect2(FENCE_LEFT, top, FENCE_RIGHT - FENCE_LEFT, FENCE_DEPTH), # haut
		Rect2(FENCE_LEFT, top, FENCE_SIDE, FENCE_FRONT_BASE - top), # gauche
		Rect2(FENCE_RIGHT - FENCE_SIDE, top, FENCE_SIDE, FENCE_FRONT_BASE - top), # droite
		Rect2(FENCE_LEFT, bottom, gap_left - FENCE_LEFT, FENCE_DEPTH), # bas, à gauche de la porte
		Rect2(gap_right, bottom, FENCE_RIGHT - gap_right, FENCE_DEPTH), # bas, à droite
	]
	for r in rects:
		var shape := RectangleShape2D.new()
		shape.size = r.size
		var collision := CollisionShape2D.new()
		collision.shape = shape
		collision.position = r.get_center()
		body.add_child(collision)
	return body


## Noeud placé au point de tri, qui porte layer décalé d'autant vers le haut.
static func _sort_anchor(sort_point: Vector2, layer: Node2D) -> Node2D:
	var anchor := Node2D.new()
	anchor.position = sort_point
	anchor.add_child(layer)
	return anchor


## Pseudo-hasard 0-99 fixe par case : la carte est identique à chaque lancement.
func _noise(x: int, y: int) -> int:
	return absi((x * 73856093) ^ (y * 19349663)) % 100
