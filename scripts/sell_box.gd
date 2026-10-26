class_name SellBox
extends Station
## Boîte de vente : dépose tout le blé porté et verse l'argent.
## Plus tard : l'argent sera versé en fin de journée (voir GameState.sell_all_wheat).


func _init() -> void:
	title = "Boite"
	body_color = Color(0.6, 0.4, 0.2)


func prompt() -> String:
	return "[F] Vendre le ble (%d)" % GameState.wheat


func interact() -> void:
	GameState.sell_all_wheat()
