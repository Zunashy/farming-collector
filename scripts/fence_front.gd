extends Node2D
## Nouvelle porte dessinée à sa taille, avec poteaux et traverses proportionnés.
const TEXTURE := preload("res://assets/pack_v2/fence_v3_front.png")
const OPEN_GATE := preload("res://assets/pack_v2/fence_gate_open.png")

var is_open := false:
	set(value):
		if is_open != value:
			is_open = value
			queue_redraw()
var _close_delay := 0.0


func _process(delta: float) -> void:
	var gate_center := to_global(Vector2(80, 170))
	var nearby := false
	for actor in get_parent().get_parent().get_children():
		if actor is Player or actor is Employee:
			var distance: Vector2 = actor.global_position - gate_center
			if absf(distance.x) < 25 and absf(distance.y) < 38:
				nearby = true
				break
	_close_delay = 0.8 if nearby else maxf(0.0, _close_delay - delta)
	is_open = _close_delay > 0.0


func _draw() -> void:
	if not is_open:
		draw_texture(TEXTURE, Vector2.ZERO)
		return
	# Seule la zone du portail change, les traverses voisines restent intactes.
	draw_texture_rect_region(TEXTURE, Rect2(0, 0, 64, 192), Rect2(0, 0, 64, 192))
	draw_texture_rect_region(TEXTURE, Rect2(108, 0, 84, 192), Rect2(108, 0, 84, 192))
	draw_texture(OPEN_GATE, Vector2(64, 128))
