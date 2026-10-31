extends Node2D
## Nouvelle porte dessinée à sa taille, avec poteaux et traverses proportionnés.
const TEXTURE := preload("res://assets/pack_v2/fence_v3_front.png")


func _draw() -> void:
	draw_texture(TEXTURE, Vector2.ZERO)
