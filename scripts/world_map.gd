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

const GRASS := preload("res://assets/sprites/grass.png")
const FLOWERS_WHITE := preload("res://assets/sprites/flowers_white.png")
const FLOWERS_MIXED := preload("res://assets/sprites/flowers_mixed.png")
const DIRT_PLAIN := preload("res://assets/sprites/dirt_plain.png")
const DIRT_PEBBLES := preload("res://assets/sprites/dirt_pebbles.png")
const FENCE_H := preload("res://assets/sprites/fence_horizontal.png")
const FENCE_V := preload("res://assets/sprites/fence_vertical.png")
const FENCE_NW := preload("res://assets/sprites/fence_corner_nw.png")
const FENCE_NE := preload("res://assets/sprites/fence_corner_ne.png")
const FENCE_SW := preload("res://assets/sprites/fence_corner_sw.png")
const FENCE_SE := preload("res://assets/sprites/fence_corner_se.png")
const FENCE_GATE := preload("res://assets/sprites/fence_gate.png")


## Coin haut gauche des 4x4 cases du champ.
static func field_position(index: int) -> Vector2:
	return Vector2((FIELD_BLOCK_COLS[index] + 1) * TILE, (BLOCK_ROW + 1) * TILE)


## Point sur le chemin, juste devant la porte de l'enclos.
static func gate_front(index: int) -> Vector2:
	var col := FIELD_BLOCK_COLS[index] + GATE_OFFSET
	return Vector2(col * TILE + TILE / 2.0, (BLOCK_ROW + BLOCK_SIZE + 1) * TILE + TILE / 2.0)


static func sell_box_position() -> Vector2:
	return Vector2(SELL_TILE) * TILE + Vector2(TILE, TILE) / 2.0


func _draw() -> void:
	var dirt := _dirt_tiles()
	for y in ROWS:
		for x in COLS:
			var pos := Vector2(x, y) * TILE
			var n := _noise(x, y)
			if dirt.has(Vector2i(x, y)):
				draw_texture(DIRT_PEBBLES if n < 25 else DIRT_PLAIN, pos)
			elif n < 8:
				draw_texture(FLOWERS_WHITE, pos)
			elif n < 14:
				draw_texture(FLOWERS_MIXED, pos)
			else:
				draw_texture(GRASS, pos)
	_draw_fences()


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


## Les sprites de clôture ne sont pas centrés au même endroit dans leur tuile 32x32 (mesuré) :
##   rails horizontaux y 12-21 (centre 16,5)   trait vertical x 14-17 (centre 15,5)
##   angles du haut : rails y 6-13 (centre 9,5)   angles du bas : rails y 18-25 (centre 21,5)
##   angles de gauche : poteau x 6-11 (centre 8,5)   angles de droite : poteau x 20-25 (centre 22,5)
## Chaque pièce est donc décalée pour que rails et poteaux se rejoignent, puis toute la clôture est
## rapprochée du champ de FENCE_INSET pixels (sinon 22 px d'herbe la sépareraient du champ).
const FENCE_INSET := 10.0


func _draw_fences() -> void:
	var d := FENCE_INSET
	var top := Vector2(0, d - 7.0)
	var bottom := Vector2(0, 5.0 - d)
	var left := Vector2(d - 7.0, 0)
	var right := Vector2(7.0 - d, 0)
	var last := BLOCK_SIZE - 1
	for c0 in FIELD_BLOCK_COLS:
		for i in range(1, last):
			_draw_tile(FENCE_H, c0 + i, BLOCK_ROW, top)
			_draw_tile(FENCE_GATE if i == GATE_OFFSET else FENCE_H, c0 + i, BLOCK_ROW + last, bottom)
			_draw_tile(FENCE_V, c0, BLOCK_ROW + i, left)
			_draw_tile(FENCE_V, c0 + last, BLOCK_ROW + i, right)
		_draw_tile(FENCE_NW, c0, BLOCK_ROW, Vector2(d, d))
		_draw_tile(FENCE_NE, c0 + last, BLOCK_ROW, Vector2(-d, d))
		_draw_tile(FENCE_SW, c0, BLOCK_ROW + last, Vector2(d, -d))
		_draw_tile(FENCE_SE, c0 + last, BLOCK_ROW + last, Vector2(-d, -d))


func _draw_tile(texture: Texture2D, x: int, y: int, shift := Vector2.ZERO) -> void:
	draw_texture(texture, Vector2(x, y) * TILE + shift)


## Pseudo-hasard 0-99 fixe par case : la carte est identique à chaque lancement.
func _noise(x: int, y: int) -> int:
	return absi((x * 73856093) ^ (y * 19349663)) % 100
