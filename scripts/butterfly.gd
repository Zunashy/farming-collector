class_name Butterfly
extends Node2D
## Papillon d'ambiance : vole au hasard au-dessus de la carte en battant des ailes. Aucun effet sur le jeu.

const COLORS: Array[Color] = [Color(0.98, 0.84, 0.32), Color(0.96, 0.95, 0.88)]
const BODY := Color(0.25, 0.17, 0.1)
const SPEED := 18.0
const FLAP_FPS := 6.0
const TURN_TIME := Vector2(1.5, 4.0) ## délai min / max avant de changer de cap (secondes)

var bounds := Vector2(896, 512) ## zone de vol (défini avant add_child)
var seed_value := 0 ## chaque papillon part d'un endroit et d'une couleur différents

var _rng := RandomNumberGenerator.new()
var _color := COLORS[0]
var _heading := Vector2.RIGHT
var _turn_in := 0.0
var _time := 0.0


func _ready() -> void:
	_rng.seed = 7919 + seed_value * 104729
	_color = COLORS[seed_value % COLORS.size()]
	position = Vector2(_rng.randf_range(0, bounds.x), _rng.randf_range(0, bounds.y))
	_time = _rng.randf() * 10.0
	_new_heading()


func _process(delta: float) -> void:
	_time += delta
	_turn_in -= delta
	if _turn_in <= 0:
		_new_heading()
	# Vol hésitant : un léger zigzag par-dessus le cap.
	var wobble := Vector2(cos(_time * 3.1), sin(_time * 4.3)) * 10.0
	position += (_heading * SPEED + wobble) * delta
	# Demi-tour aux bords de la carte.
	if position.x < 0 or position.x > bounds.x:
		_heading.x = -_heading.x
	if position.y < 0 or position.y > bounds.y:
		_heading.y = -_heading.y
	position = position.clamp(Vector2.ZERO, bounds)
	queue_redraw()


func _new_heading() -> void:
	_heading = Vector2.RIGHT.rotated(_rng.randf() * TAU)
	_turn_in = _rng.randf_range(TURN_TIME.x, TURN_TIME.y)


func _draw() -> void:
	var sheet: Texture2D = preload("res://assets/pack_v2/butterfly_yellow.png") if seed_value % 2 == 0 else preload("res://assets/pack_v2/butterfly_white.png")
	var frame_index := int(_time * FLAP_FPS) % 4
	draw_texture_rect_region(sheet, Rect2(-4, -4, 8, 8), Rect2(frame_index * 8, 0, 8, 8))
