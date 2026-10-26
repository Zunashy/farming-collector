class_name Player
extends CharacterBody2D
## Joueur top-down. Utilise l'outil sélectionné sur la case devant lui.

const SPEED := 120.0
const REACH := 26.0 ## distance du point visé devant le joueur

var field: FarmField
var stations: Array[Station] = []
var facing := Vector2.DOWN


func _ready() -> void:
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	shape.shape = circle
	add_child(shape)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tool_1"):
		GameState.select_tool(GameState.Tool.SEEDS)
	elif event.is_action_pressed("tool_2"):
		GameState.select_tool(GameState.Tool.WATERING_CAN)
	elif event.is_action_pressed("tool_3"):
		GameState.select_tool(GameState.Tool.HAND)
	elif event.is_action_pressed("tool_next"):
		GameState.select_tool(GameState.current_tool + 1)
	elif event.is_action_pressed("tool_prev"):
		GameState.select_tool(GameState.current_tool - 1)
	elif event.is_action_pressed("interact"):
		var station := _nearest_station()
		if station:
			station.interact()
	elif event.is_action_pressed("use_tool"):
		field.use_tool(_target_cell(), GameState.current_tool)


func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir != Vector2.ZERO:
		# Orientation sur 4 directions, pour viser une case précise.
		facing = Vector2(signf(dir.x), 0) if absf(dir.x) > absf(dir.y) else Vector2(0, signf(dir.y))
	velocity = dir * SPEED
	move_and_slide()
	var bounds := get_viewport_rect().size
	position = position.clamp(Vector2.ZERO, bounds)

	field.set_highlight(_target_cell())
	var nearest := _nearest_station()
	for s in stations:
		s.set_near(s == nearest)
	queue_redraw()


func _target_cell() -> Vector2i:
	return field.world_to_cell(global_position + facing * REACH)


func _nearest_station() -> Station:
	var best: Station = null
	var best_dist := INF
	for s in stations:
		if s.is_near(global_position):
			var d := s.global_position.distance_to(global_position)
			if d < best_dist:
				best = s
				best_dist = d
	return best


func _draw() -> void:
	# --- SPRITE : joueur animé 4 directions (marche + idle), remplace ce _draw ---
	draw_rect(Rect2(-8, -16, 16, 24), Color(0.9, 0.4, 0.35))
	draw_rect(Rect2(-8, -16, 16, 24), Color.BLACK, false, 1.5)
	draw_circle(facing * 5.0 + Vector2(0, -4), 3.0, Color.WHITE)
