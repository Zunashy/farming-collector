extends Node2D
## Monte la scène de ferme : carte, champs, boîte de vente, employés, joueur, HUD.
## Contient aussi la capture / restauration de l'état pour la sauvegarde (pas encore utilisée par le jeu).

const EMPLOYEE_NAMES: Array[String] = ["Lea", "Tom", "Mia", "Noe", "Zoe", "Max", "Eli", "Ana"]
const EMPLOYEE_COLORS: Array[Color] = [
	Color(0.4, 0.6, 0.9), Color(0.5, 0.8, 0.5), Color(0.9, 0.7, 0.3), Color(0.7, 0.5, 0.85),
	Color(0.9, 0.55, 0.65), Color(0.4, 0.8, 0.8), Color(0.85, 0.85, 0.45), Color(0.65, 0.65, 0.7),
]

var _fields: Array[FarmField] = []
var _sell_box: SellBox


func _ready() -> void:
	add_child(WorldMap.new())

	for i in WorldMap.FIELD_BLOCK_COLS.size():
		var field := FarmField.new()
		field.position = WorldMap.field_position(i)
		add_child(field)
		_fields.append(field)
	_update_fields()

	_sell_box = SellBox.new()
	_sell_box.position = WorldMap.sell_box_position()
	add_child(_sell_box)

	var player := Player.new()
	player.position = _sell_box.position + Vector2(0, 64) # sur le sentier, sous la boîte de vente
	player.bounds = WorldMap.SIZE
	player.fields = _fields
	player.stations = [_sell_box] as Array[Station]
	add_child(player)

	add_child(Hud.new())

	GameState.changed.connect(_update_fields)
	GameState.employee_hired.connect(_spawn_employee)
	_spawn_employee(0) # un employé offert au départ, rattaché au premier champ


## Les champs non achetés affichent le panneau « à vendre » et restent inactifs.
func _update_fields() -> void:
	for i in _fields.size():
		_fields[i].owned = i < GameState.fields_owned


## Crée un employé : neuf (prénom libre, devant la porte de son champ) ou restauré depuis `saved`.
func _spawn_employee(field_index: int, saved := {}) -> void:
	var employee := Employee.new()
	employee.field_index = field_index
	employee.all_fields = _fields
	employee.sell_box = _sell_box
	if saved.is_empty():
		var index := _free_name_index()
		employee.employee_name = EMPLOYEE_NAMES[index]
		employee.color = EMPLOYEE_COLORS[index]
		# Les employés d'un même champ apparaissent côte à côte devant sa porte.
		var slot := GameState.employees_on_field(field_index)
		employee.position = WorldMap.gate_front(field_index) + Vector2((slot - 1) * 26, 0)
	else:
		employee.load_dict(saved)
	add_child(employee)
	GameState.register_employee(employee)


## Premier prénom non utilisé par un employé actuel.
func _free_name_index() -> int:
	var used: Array[String] = []
	for e in GameState.employees:
		used.append(e.employee_name)
	for i in EMPLOYEE_NAMES.size():
		if not used.has(EMPLOYEE_NAMES[i]):
			return i
	return 0


# --- Sauvegarde (3 emplacements, voir SaveGame). Rien ne l'appelle encore. ---

func capture_state() -> Dictionary:
	var fields: Array = []
	for f in _fields:
		fields.append(f.to_dict())
	var employees: Array = []
	for e in GameState.employees:
		employees.append(e.to_dict())
	return {"game": GameState.to_dict(), "fields": fields, "employees": employees}


func restore_state(state: Dictionary) -> void:
	GameState.clear_employees()
	GameState.from_dict(state.get("game", {}))
	var saved_fields: Array = state.get("fields", [])
	for i in mini(saved_fields.size(), _fields.size()):
		_fields[i].from_dict(saved_fields[i])
	_update_fields()
	for saved in state.get("employees", []):
		_spawn_employee(int(saved.get("field_index", 0)), saved)


func save_game(slot: int) -> bool:
	return SaveGame.write(slot, capture_state())


func load_game(slot: int) -> bool:
	var state := SaveGame.read(slot)
	if state.is_empty():
		return false
	restore_state(state)
	return true
