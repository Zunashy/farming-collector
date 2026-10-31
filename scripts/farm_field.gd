class_name FarmField
extends Node2D
## Grille de parcelles : planter, arroser, récolter.
## Un plant a 4 stades (0 graine, 1 pousse, 2 presque mûr, 3 mûr).
## Chaque stade avance seulement si le plant a été arrosé, puis la terre sèche à nouveau.

const TILE := 32
const COLS := 4
const ROWS := 4
const RIPE_STAGE := 3
const GROW_TIME := 6.0 ## secondes entre deux stades une fois arrosé

const NO_PLANT := -1
const NO_CELL := Vector2i(-1, -1)

const SOIL_DRY := preload("res://assets/sprites/soil_dry.png")
const SOIL_WET := preload("res://assets/sprites/soil_wet.png")
const FOR_SALE := preload("res://assets/sprites/field_for_sale.png")
## Icône de l'action affichée sur la case visée, indexée par GameState.Tool.
const ACTION_ICONS: Array[Texture2D] = [
	preload("res://assets/sprites/icon_seeds.png"),
	preload("res://assets/sprites/icon_can.png"),
	preload("res://assets/sprites/icon_hand.png"),
]
const WHEAT: Array[Texture2D] = [
	preload("res://assets/sprites/wheat_0.png"),
	preload("res://assets/sprites/wheat_1.png"),
	preload("res://assets/sprites/wheat_2.png"),
	preload("res://assets/sprites/wheat_3.png"),
]

## Un champ non acheté affiche le panneau « à vendre » et reste inactif.
var owned := true:
	set(value):
		owned = value
		set_process(value)
		queue_redraw()

var _stage := PackedInt32Array()
var _watered := PackedByteArray()
var _timer := PackedFloat32Array()
var _claims := {} ## index de case -> Employee qui s'en occupe
var highlight_cell := Vector2i(-1, -1)


func _ready() -> void:
	var count := COLS * ROWS
	_stage.resize(count)
	_stage.fill(NO_PLANT)
	_watered.resize(count)
	_timer.resize(count)


func _process(delta: float) -> void:
	var dirty := false
	for i in _stage.size():
		if _stage[i] == NO_PLANT or _stage[i] >= RIPE_STAGE or _watered[i] == 0:
			continue
		_timer[i] += delta
		if _timer[i] >= GROW_TIME:
			_timer[i] = 0.0
			_stage[i] += 1
			_watered[i] = 0
			dirty = true
	if dirty:
		queue_redraw()


## État des plants, pour la sauvegarde.
func to_dict() -> Dictionary:
	return {"stage": Array(_stage), "watered": Array(_watered), "timer": Array(_timer)}


func from_dict(data: Dictionary) -> void:
	var stage: Array = data.get("stage", [])
	var watered: Array = data.get("watered", [])
	var timer: Array = data.get("timer", [])
	for i in _stage.size():
		_stage[i] = clampi(int(stage[i]), NO_PLANT, RIPE_STAGE) if i < stage.size() else NO_PLANT
		_watered[i] = int(watered[i]) if i < watered.size() else 0
		_timer[i] = float(timer[i]) if i < timer.size() else 0.0
	_claims.clear()
	queue_redraw()


func world_to_cell(world_pos: Vector2) -> Vector2i:
	var local := to_local(world_pos)
	return Vector2i(floori(local.x / TILE), floori(local.y / TILE))


func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < COLS and cell.y < ROWS


func cell_center(cell: Vector2i) -> Vector2:
	return to_global(Vector2((cell.x + 0.5) * TILE, (cell.y + 0.5) * TILE))


## Vrai si l'outil aurait un effet sur cette case.
func can_use_tool(cell: Vector2i, tool_id: GameState.Tool) -> bool:
	var i := cell.y * COLS + cell.x
	match tool_id:
		GameState.Tool.SEEDS:
			return _stage[i] == NO_PLANT and GameState.seeds > 0
		GameState.Tool.WATERING_CAN:
			return _stage[i] != NO_PLANT and _stage[i] < RIPE_STAGE and _watered[i] == 0
		GameState.Tool.HAND:
			return _stage[i] == RIPE_STAGE
	return false


## Outil le plus utile sur cette case (récolter > arroser > planter), ou -1 s'il n'y a rien à faire.
func auto_tool(cell: Vector2i) -> int:
	if not in_bounds(cell):
		return -1
	var order: Array[int] = [GameState.Tool.HAND, GameState.Tool.WATERING_CAN, GameState.Tool.SEEDS]
	for t in order:
		if can_use_tool(cell, t as GameState.Tool):
			return t
	return -1


## Action de la touche E : applique automatiquement l'outil utile sur la case.
func use_auto(cell: Vector2i) -> void:
	var t := auto_tool(cell)
	if t != -1:
		use_tool(cell, t as GameState.Tool)


## Case utile non réservée la plus proche de from_world, ou NO_CELL. Ne réserve rien (voir reserve_job).
func peek_job(tool_id: GameState.Tool, from_world: Vector2) -> Vector2i:
	var best := NO_CELL
	var best_dist := INF
	for y in ROWS:
		for x in COLS:
			var cell := Vector2i(x, y)
			if _claims.has(y * COLS + x) or not can_use_tool(cell, tool_id):
				continue
			var d := cell_center(cell).distance_squared_to(from_world)
			if d < best_dist:
				best = cell
				best_dist = d
	return best


## Réserve la case pour who : les autres employés ne la choisiront pas.
func reserve_job(cell: Vector2i, who: Object) -> void:
	_claims[cell.y * COLS + cell.x] = who


func release_job(cell: Vector2i, who: Object) -> void:
	var i := cell.y * COLS + cell.x
	if _claims.get(i) == who:
		_claims.erase(i)


func set_highlight(cell: Vector2i) -> void:
	if cell != highlight_cell:
		highlight_cell = cell
		queue_redraw()


func use_tool(cell: Vector2i, tool_id: GameState.Tool) -> void:
	if not in_bounds(cell):
		return
	var i := cell.y * COLS + cell.x
	match tool_id:
		GameState.Tool.SEEDS:
			if _stage[i] == NO_PLANT and GameState.use_seed():
				_stage[i] = 0
				_watered[i] = 0
				_timer[i] = 0.0
		GameState.Tool.WATERING_CAN:
			if _stage[i] != NO_PLANT and _stage[i] < RIPE_STAGE:
				_watered[i] = 1
		GameState.Tool.HAND:
			if _stage[i] == RIPE_STAGE:
				_stage[i] = NO_PLANT
				_watered[i] = 0
				GameState.add_wheat(1)
	queue_redraw()


func _draw() -> void:
	if not owned:
		draw_texture(FOR_SALE, Vector2.ZERO)
		return
	for y in ROWS:
		for x in COLS:
			var i := y * COLS + x
			var pos := Vector2(x * TILE, y * TILE)
			draw_texture(SOIL_WET if _watered[i] == 1 else SOIL_DRY, pos)
			if _stage[i] != NO_PLANT:
				draw_texture(WHEAT[_stage[i]], pos)
	if in_bounds(highlight_cell):
		var hr := Rect2(highlight_cell.x * TILE, highlight_cell.y * TILE, TILE, TILE)
		draw_rect(hr, Color(1, 1, 1, 0.9), false, 2.0)
		var action := auto_tool(highlight_cell)
		if action != -1:
			draw_texture(ACTION_ICONS[action], hr.position + Vector2(TILE - 18, 2))
