class_name SellBox
extends Station
## Boîte de vente : dépose tout le blé porté et verse l'argent.
## Plus tard : l'argent sera versé en fin de journée (voir GameState.sell_all_wheat).


func _init() -> void:
	title = "Boite"
	body_color = Color(0.6, 0.4, 0.2)
	texture = preload("res://assets/pack_v2/sell_box.png")
	body_size = Vector2(64, 32)


func prompt() -> String:
	return "[F] Vendre le ble (%d)" % GameState.wheat


func interact() -> void:
	if GameState.wheat <= 0:
		GameState.notify("Rien a vendre : recolte du ble d'abord")
		return
	GameState.sell_all_wheat()
