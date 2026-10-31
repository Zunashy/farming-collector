class_name Station
extends Node2D
## Objet interactif posé dans le monde (boîte de vente, boutique...). Touche "interact" (F) à proximité.

const INTERACT_RANGE := 56.0

var title := ""
var body_size := Vector2(40, 32)
var body_color := Color.GRAY
var texture: Texture2D ## si défini, remplace le rectangle coloré
var near := false


func is_near(world_pos: Vector2) -> bool:
	return global_position.distance_to(world_pos) <= INTERACT_RANGE


func set_near(value: bool) -> void:
	if value != near:
		near = value
		queue_redraw()


## À surcharger : texte d'aide affiché quand le joueur est proche.
func prompt() -> String:
	return ""


## À surcharger : action de la touche "interact".
func interact() -> void:
	pass


func _draw() -> void:
	var rect := Rect2(-body_size / 2.0, body_size)
	if texture:
		draw_texture(texture, rect.position)
	else:
		draw_rect(rect, body_color)
		draw_rect(rect, Color.BLACK, false, 2.0)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-body_size.x / 2.0, -body_size.y / 2.0 - 4), title, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)
	if near: # texte réduit : le monde est affiché en zoom x2
		draw_string(font, Vector2(-70, body_size.y / 2.0 + 12), prompt(), HORIZONTAL_ALIGNMENT_CENTER, 140, 8, Color.WHITE)
