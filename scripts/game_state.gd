extends Node
## État global du jeu (autoload "GameState") : argent, inventaire, champs, employés.

signal changed
signal employees_changed
signal employee_hired(field_index: int) ## Main crée l'employé puis l'enregistre (register_employee)
signal employee_menu_requested(employee: Node)

enum Tool { SEEDS, WATERING_CAN, HAND }

const SEED_PRICE := 3
const SEED_SELL_PRICE := 1
const WHEAT_PRICE := 8
const EMPLOYEE_PRICE := 50
const EMPLOYEE_SELL_PRICE := 25
const MAX_EMPLOYEES := 8
const MAX_PER_FIELD := 3
const FIELD_PRICES: Array[int] = [100, 500] ## prix du 2e et du 3e champ
const MAX_FIELDS := 3

var money := 0
var seeds := 5
var wheat := 0
var fields_owned := 1
var employees: Array = [] ## Employee (non typé : évite une dépendance circulaire)


func _ready() -> void:
	_setup_inputs()


## Données à sauvegarder (les employés et les champs sont gérés par Main et FarmField).
func to_dict() -> Dictionary:
	return {"money": money, "seeds": seeds, "wheat": wheat, "fields_owned": fields_owned}


func from_dict(data: Dictionary) -> void:
	money = int(data.get("money", 0))
	seeds = int(data.get("seeds", 5))
	wheat = int(data.get("wheat", 0))
	fields_owned = clampi(int(data.get("fields_owned", 1)), 1, MAX_FIELDS)
	changed.emit()


## Supprime tous les employés (avant de recharger une sauvegarde).
func clear_employees() -> void:
	for e in employees:
		e.queue_free()
	employees.clear()
	employees_changed.emit()


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


func sell_seed() -> bool:
	if seeds <= 0:
		return false
	seeds -= 1
	money += SEED_SELL_PRICE
	changed.emit()
	return true


func employees_on_field(field_index: int) -> int:
	var count := 0
	for e in employees:
		if e.field_index == field_index:
			count += 1
	return count


## Premier champ possédé ayant une place libre, ou -1.
func free_field_slot() -> int:
	for i in fields_owned:
		if employees_on_field(i) < MAX_PER_FIELD:
			return i
	return -1


func can_hire() -> bool:
	return employees.size() < MAX_EMPLOYEES and free_field_slot() != -1


func buy_employee() -> bool:
	if not can_hire() or money < EMPLOYEE_PRICE:
		return false
	money -= EMPLOYEE_PRICE
	employee_hired.emit(free_field_slot())
	changed.emit()
	return true


func register_employee(employee: Node) -> void:
	employees.append(employee)
	employees_changed.emit()


func sell_employee(employee: Node) -> void:
	if not employees.has(employee):
		return
	employees.erase(employee)
	employee.queue_free()
	money += EMPLOYEE_SELL_PRICE
	employees_changed.emit()
	changed.emit()


## Prix du prochain champ, ou -1 s'ils sont tous achetés.
func next_field_price() -> int:
	if fields_owned >= MAX_FIELDS:
		return -1
	return FIELD_PRICES[fields_owned - 1]


func buy_field() -> bool:
	var price := next_field_price()
	if price < 0 or money < price:
		return false
	money -= price
	fields_owned += 1
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
	# Lettres ZQSD par leur caractère, au cas où la disposition du clavier n'est pas AZERTY.
	_add_letters("move_left", [KEY_Q])
	_add_letters("move_right", [KEY_D])
	_add_letters("move_up", [KEY_Z])
	_add_letters("move_down", [KEY_S])
	_add_keys("use_tool", [KEY_E, KEY_SPACE])
	_add_keys("interact", [KEY_F])
	_add_keys("market", [KEY_B])


func _add_keys(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for key in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = key
		InputMap.action_add_event(action, ev)


func _add_letters(action: String, keys: Array) -> void:
	for key in keys:
		var ev := InputEventKey.new()
		ev.keycode = key
		InputMap.action_add_event(action, ev)
