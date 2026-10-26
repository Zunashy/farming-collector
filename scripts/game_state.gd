extends Node
## État global du jeu (autoload "GameState") : argent, inventaire, outil sélectionné.

signal changed

enum Tool { SEEDS, WATERING_CAN, HAND }

const TOOL_NAMES: Array[String] = ["Graines", "Arrosoir", "Main"]
const SEED_PRICE := 3
const WHEAT_PRICE := 8

var money := 0
var seeds := 5
var wheat := 0
var current_tool: Tool = Tool.SEEDS


func _ready() -> void:
	_setup_inputs()


func select_tool(tool_id: int) -> void:
	current_tool = wrapi(tool_id, 0, TOOL_NAMES.size()) as Tool
	changed.emit()


func add_seeds(amount: int) -> void:
	seeds += amount
	changed.emit()


func add_wheat(amount: int) -> void:
	wheat += amount
	changed.emit()


func buy_seed() -> bool:
	if money < SEED_PRICE:
		return false
	money -= SEED_PRICE
	seeds += 1
	changed.emit()
	return true


## Vend tout le blé porté. Renvoie le montant gagné.
func sell_all_wheat() -> int:
	var gain := wheat * WHEAT_PRICE
	wheat = 0
	money += gain
	changed.emit()
	return gain


func use_seed() -> bool:
	if seeds <= 0:
		return false
	seeds -= 1
	changed.emit()
	return true


# Touches physiques : WASD = ZQSD sur clavier AZERTY.
func _setup_inputs() -> void:
	_add_keys("move_left", [KEY_A, KEY_LEFT])
	_add_keys("move_right", [KEY_D, KEY_RIGHT])
	_add_keys("move_up", [KEY_W, KEY_UP])
	_add_keys("move_down", [KEY_S, KEY_DOWN])
	_add_keys("use_tool", [KEY_E, KEY_SPACE])
	_add_keys("interact", [KEY_F])
	_add_keys("tool_1", [KEY_1])
	_add_keys("tool_2", [KEY_2])
	_add_keys("tool_3", [KEY_3])
	_add_mouse("tool_next", MOUSE_BUTTON_WHEEL_DOWN)
	_add_mouse("tool_prev", MOUSE_BUTTON_WHEEL_UP)


func _add_keys(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = key
		InputMap.action_add_event(action, ev)


func _add_mouse(action: String, button: MouseButton) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var ev := InputEventMouseButton.new()
	ev.button_index = button
	InputMap.action_add_event(action, ev)
