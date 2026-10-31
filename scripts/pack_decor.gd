extends RefCounted
## Décors sans collision sur les marges ; tous sont ancrés au sol pour le tri Y.
static func populate(parent: Node2D) -> void:
	var placements := [
		["tree_apple_trunk", Vector2(80, 166)],
		["tree_apple_canopy", Vector2(80, 120)],
		["seed_bag", Vector2(153, 223)],
		["basket_apples", Vector2(75, 240)],
		["basket_tomatoes", Vector2(156, 260)],
		["pitchfork", Vector2(173, 240)],
		["signpost", Vector2(62, 215)],
		["bush_1", Vector2(40, 478)],
		["bush_2", Vector2(390, 494)],
		["bush_3", Vector2(855, 490)],
		["rock_medium", Vector2(485, 393)],
	]
	var rng := RandomNumberGenerator.new()
	rng.seed = 731
	var details := ["flowers_white_1", "flowers_yellow_1", "flowers_purple_1", "flowers_mixed_2", "lavender_1", "lavender_2", "tall_grass_1", "tall_grass_2", "tall_grass_3", "rock_small"]
	for i in 90:
		placements.append([details[i % details.size()], Vector2(rng.randi_range(18, 878), rng.randi_range(394, 503))])
	for p in placements:
		var texture := load("res://assets/pack_v2/%s.png" % p[0]) as Texture2D
		var sprite := Sprite2D.new()
		sprite.texture = texture
		sprite.position = p[1]
		sprite.offset = Vector2(0, -texture.get_height() / 2.0)
		parent.add_child(sprite)
