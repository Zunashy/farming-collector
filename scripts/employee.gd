class_name Employee
extends Node2D
## Employé : travaille seul selon sa tâche (planter, arroser, récolter, ou vendre le blé).
## Il travaille sur tous les champs achetés, au plus près de lui, sauf si son menu le restreint
## à un seul champ (work_field). Le menu s'ouvre par clic droit sur lui ou depuis la liste du HUD
## (voir EmployeeMenu).

enum Task { IDLE, PLANT, WATER, HARVEST, SELL }

const TASK_NAMES: Array[String] = ["Repos", "Planter", "Arroser", "Recolter", "Vendre"]
const WORKING_STATUS: Array[String] = ["Repos", "Plante...", "Arrose...", "Recolte...", "Vend..."]
## Icône de chaque tâche, dans l'ordre de Task.
const TASK_ICONS: Array[Texture2D] = [
	preload("res://assets/sprites/task_rest.png"),
	preload("res://assets/sprites/task_plant.png"),
	preload("res://assets/sprites/task_water.png"),
	preload("res://assets/sprites/task_harvest.png"),
	preload("res://assets/sprites/task_sell.png"),
]
const SPEED := 60.0
const WORK_TIME := 0.7 ## secondes passées sur une case
const ARRIVE_DIST := 3.0
const HIT_RECT := Rect2(-12, -40, 24, 50) ## zone de clic droit (le sprite est agrandi, voir CharacterSprite)
const SHEET := preload("res://assets/sprites/employee.png")

var employee_name := ""
var color := Color(0.4, 0.6, 0.9)
var field_index := 0 ## champ de rattachement : sert à la place occupée (3 par champ) et au point d'apparition
var work_field := -1 ## -1 : tous les champs achetés ; sinon l'index du seul champ où il travaille
var all_fields: Array[FarmField] = []
var sell_box: Station ## où l'employé porte le blé pour la tâche "Vendre"
var task: Task = Task.IDLE
var status := "Repos"
var waiting := false ## vrai quand la tâche est choisie mais qu'il n'y a rien à faire (grisé dans les menus)
var selected := false:
	set(value):
		selected = value
		queue_redraw()

var _cell := FarmField.NO_CELL
var _job_field: FarmField ## champ de la case en cours (_cell)
var _work := 0.0
var _sprite: CharacterSprite


func _ready() -> void:
	_sprite = CharacterSprite.new(SHEET)
	_sprite.modulate = Color.WHITE.lerp(color, 0.45) # la feuille est neutre : teinte légère par employé
	add_child(_sprite)


func set_task(value: Task) -> void:
	if value == task:
		return
	_drop_job()
	task = value
	status = WORKING_STATUS[task]


## Restreint l'employé à un champ (index), ou à tous les champs achetés (-1).
func set_work_field(index: int) -> void:
	if index == work_field:
		return
	_drop_job()
	work_field = index


func _exit_tree() -> void:
	_drop_job()


## Données à sauvegarder.
func to_dict() -> Dictionary:
	return {
		"name": employee_name,
		"color": [color.r, color.g, color.b],
		"field_index": field_index,
		"work_field": work_field,
		"task": task,
		"pos": [global_position.x, global_position.y],
	}


## Restaure un employé avant son ajout à la scène.
func load_dict(data: Dictionary) -> void:
	employee_name = str(data.get("name", employee_name))
	var rgb: Array = data.get("color", [])
	if rgb.size() == 3:
		color = Color(float(rgb[0]), float(rgb[1]), float(rgb[2]))
	field_index = int(data.get("field_index", field_index))
	work_field = int(data.get("work_field", -1))
	task = clampi(int(data.get("task", 0)), 0, TASK_NAMES.size() - 1) as Task
	status = WORKING_STATUS[task]
	var pos: Array = data.get("pos", [])
	if pos.size() == 2:
		position = Vector2(float(pos[0]), float(pos[1]))


func _unhandled_input(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if click and click.pressed and click.button_index == MOUSE_BUTTON_RIGHT:
		if HIT_RECT.has_point(to_local(get_global_mouse_position())):
			get_viewport().set_input_as_handled()
			GameState.employee_menu_requested.emit(self)


func _process(delta: float) -> void:
	_sprite.set_moving(false)
	waiting = false
	if task == Task.IDLE:
		return
	if task == Task.SELL:
		_process_sell(delta)
		return
	var tool_id := _tool()
	if _cell == FarmField.NO_CELL and not _claim_job(tool_id):
		waiting = true
		status = "Plus de graines" if task == Task.PLANT and GameState.seeds <= 0 else "Rien a faire"
		return
	if not _job_field.owned or not _job_field.can_use_tool(_cell, tool_id):
		_drop_job() # la case a changé entre-temps (récoltée par le joueur, graines épuisées...)
		return
	status = WORKING_STATUS[task]
	var target := _job_field.cell_center(_cell)
	if global_position.distance_to(target) > ARRIVE_DIST:
		_sprite.set_facing(target - global_position)
		_sprite.set_moving(true)
		global_position = global_position.move_toward(target, SPEED * delta)
		return
	_work += delta
	if _work >= WORK_TIME:
		_job_field.use_tool(_cell, tool_id)
		_drop_job()


## Va devant la boîte de vente et y vend tout le blé en stock.
func _process_sell(delta: float) -> void:
	if GameState.wheat <= 0:
		_work = 0.0
		waiting = true
		status = "Rien a vendre"
		return
	status = WORKING_STATUS[task]
	var target := sell_box.global_position + Vector2(0, 26)
	if global_position.distance_to(target) > ARRIVE_DIST:
		_sprite.set_facing(target - global_position)
		_sprite.set_moving(true)
		global_position = global_position.move_toward(target, SPEED * delta)
		return
	_work += delta
	if _work >= WORK_TIME:
		_work = 0.0
		GameState.sell_all_wheat()


func _tool() -> GameState.Tool:
	match task:
		Task.PLANT:
			return GameState.Tool.SEEDS
		Task.WATER:
			return GameState.Tool.WATERING_CAN
	return GameState.Tool.HAND


## Réserve la case utile la plus proche, tous champs autorisés confondus. Faux s'il n'y en a pas.
func _claim_job(tool_id: GameState.Tool) -> bool:
	var best_field: FarmField = null
	var best_cell := FarmField.NO_CELL
	var best_dist := INF
	for i in all_fields.size():
		var f := all_fields[i]
		if not f.owned or (work_field != -1 and i != work_field):
			continue
		var cell := f.peek_job(tool_id, global_position)
		if cell == FarmField.NO_CELL:
			continue
		var d := f.cell_center(cell).distance_squared_to(global_position)
		if d < best_dist:
			best_field = f
			best_cell = cell
			best_dist = d
	if not best_field:
		return false
	best_field.reserve_job(best_cell, self)
	_job_field = best_field
	_cell = best_cell
	return true


func _drop_job() -> void:
	if _cell != FarmField.NO_CELL and is_instance_valid(_job_field):
		_job_field.release_job(_cell, self)
	_cell = FarmField.NO_CELL
	_job_field = null
	_work = 0.0


func _draw() -> void:
	# Dessiné sous le sprite : anneau de sélection aux pieds, prénom au-dessus de la tête.
	if selected:
		draw_arc(Vector2(0, 8), 14.0, 0.0, TAU, 24, Color.WHITE, 2.0)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(-30, -44), employee_name, HORIZONTAL_ALIGNMENT_CENTER, 60, 8, Color.WHITE)
