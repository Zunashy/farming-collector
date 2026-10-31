class_name Player
extends CharacterBody2D
## Joueur top-down. Agit sur la case devant lui (récolter, arroser ou planter selon son état). Porte la caméra.

const SPEED := 100.0
const ZOOM := 2.0
const REACH := 26.0 ## distance du point visé devant le joueur
const SHEET := preload("res://assets/sprites/player.png")

var bounds := Vector2(896, 512) ## taille du monde (défini avant add_child) : limite du joueur et de la caméra
var fields: Array[FarmField] = []
var stations: Array[Station] = []
var facing := Vector2.DOWN

var _sprite: CharacterSprite


func _ready() -> void:
	_sprite = CharacterSprite.new(SHEET)
	add_child(_sprite)
	# La caméra suit le joueur sans sortir de la carte. Zoom entier : pixels nets.
	var camera := Camera2D.new()
	camera.zoom = Vector2(ZOOM, ZOOM)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(bounds.x)
	camera.limit_bottom = int(bounds.y)
	add_child(camera)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	shape.shape = circle
	add_child(shape)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		var station := _nearest_station()
		if station:
			station.interact()
	elif event.is_action_pressed("use_tool"):
		var target := _target_point()
		for f in fields:
			if f.owned:
				f.use_auto(f.world_to_cell(target))


func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir != Vector2.ZERO:
		# Orientation sur 4 directions, pour viser une case précise.
		var new_facing := Vector2(signf(dir.x), 0) if absf(dir.x) > absf(dir.y) else Vector2(0, signf(dir.y))
		facing = new_facing
	_sprite.set_facing(facing)
	_sprite.set_moving(dir != Vector2.ZERO)
	velocity = dir * SPEED
	move_and_slide()
	position = position.clamp(Vector2.ZERO, bounds)

	var target := _target_point()
	for f in fields:
		f.set_highlight(f.world_to_cell(target) if f.owned else Vector2i(-1, -1))
	var nearest := _nearest_station()
	for s in stations:
		s.set_near(s == nearest)


func _target_point() -> Vector2:
	return global_position + facing * REACH


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
