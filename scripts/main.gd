extends Node2D
## Monte la scène de ferme : champ, boîte de vente, boutique, joueur, HUD.


func _ready() -> void:
	var field := FarmField.new()
	field.position = Vector2(380, 170)
	add_child(field)

	var sell_box := SellBox.new()
	sell_box.position = Vector2(260, 200)
	add_child(sell_box)

	var shop := Shop.new()
	shop.position = Vector2(260, 320)
	add_child(shop)

	var player := Player.new()
	player.position = Vector2(330, 260)
	player.field = field
	player.stations = [sell_box, shop] as Array[Station]
	add_child(player)

	add_child(Hud.new())
