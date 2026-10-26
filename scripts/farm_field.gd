class_name FarmField
extends Node2D
## Grille de parcelles : planter, arroser, récolter.
## Un plant a 4 stades (0 graine, 1 pousse, 2 presque mûr, 3 mûr).
## Chaque stade avance seulement si le plant a été arrosé, puis la terre sèche à nouveau.

const TILE := 32
const COLS := 8
const ROWS := 5
const RIPE_STAGE := 3
const GROW_TIME := 6.0 ## secondes entre deux stades une fois arrosé

const NO_PLANT := -1

var _stage := PackedInt32Array()
var _watered := PackedByteArray()
var _timer := PackedFloat32Array()
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


func world_to_cell(world_pos: Vector2) -> Vector2i:
	var local := to_local(world_pos)
	return Vector2i(floori(local.x / TILE), floori(local.y / TILE))


func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < COLS and cell.y < ROWS


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
	# --- SPRITE : sol de terre sèche / arrosée (tuile 32x32) ---
	# --- SPRITE : blé, 4 stades de croissance (32x32 chacun) ---
	for y in ROWS:
		for x in COLS:
			var i := y * COLS + x
			var rect := Rect2(x * TILE, y * TILE, TILE, TILE)
			var wet := _watered[i] == 1
			draw_rect(rect, Color(0.33, 0.2, 0.1) if wet else Color(0.55, 0.38, 0.2))
			draw_rect(rect, Color(0, 0, 0, 0.25), false, 1.0)
			_draw_plant(rect, _stage[i])
	if in_bounds(highlight_cell):
		var hr := Rect2(highlight_cell.x * TILE, highlight_cell.y * TILE, TILE, TILE)
		draw_rect(hr, Color(1, 1, 1, 0.9), false, 2.0)


func _draw_plant(rect: Rect2, stage: int) -> void:
	if stage == NO_PLANT:
		return
	var c := rect.get_center()
	match stage:
		0:
			draw_circle(c, 3.0, Color(0.85, 0.75, 0.4))
		1:
			draw_rect(Rect2(c.x - 2, c.y - 6, 4, 12), Color(0.45, 0.75, 0.3))
		2:
			for dx in [-8, 0, 8]:
				draw_rect(Rect2(c.x + dx - 2, c.y - 11, 4, 22), Color(0.5, 0.8, 0.25))
		RIPE_STAGE:
			for dx in [-9, -3, 3, 9]:
				draw_rect(Rect2(c.x + dx - 2, c.y - 13, 4, 26), Color(0.95, 0.8, 0.2))
				draw_rect(Rect2(c.x + dx - 3, c.y - 15, 6, 7), Color(1.0, 0.9, 0.35))
