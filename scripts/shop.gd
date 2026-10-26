class_name Shop
extends Station
## Boutique de graines : un appui sur "interact" achète une graine de blé.


func _init() -> void:
	title = "Boutique"
	body_size = Vector2(48, 36)
	body_color = Color(0.3, 0.5, 0.75)


func prompt() -> String:
	return "[F] Graine de ble (%d$)" % GameState.SEED_PRICE


func interact() -> void:
	GameState.buy_seed()
