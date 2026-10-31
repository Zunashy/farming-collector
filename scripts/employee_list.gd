class_name EmployeeList
extends VBoxContainer
## Liste dépliable des employés (HUD, colonne de droite) : un en-tête par employé avec l'icône de sa
## tâche, un seul menu déplié à la fois. Cliquer en dehors du menu déplié le referme.

signal opened

const WIDTH := 230.0
const MARGIN := 12.0

var _open: Employee = null
var _headers := {} ## Employee -> Button
var _sections := {} ## Employee -> VBoxContainer (en-tête + menu)
var _tints := {} ## Employee -> dernière teinte d'icône appliquée (évite de la réappliquer à chaque frame)


func _ready() -> void:
	# Accrochée en haut à droite : la colonne grandit vers le bas, son bord droit reste fixe.
	set_anchors_preset(Control.PRESET_TOP_RIGHT)
	offset_left = -MARGIN - WIDTH
	offset_right = -MARGIN
	offset_top = MARGIN
	offset_bottom = MARGIN
	custom_minimum_size = Vector2(WIDTH, 0)
	GameState.employees_changed.connect(_rebuild)
	_rebuild()


func close() -> void:
	if _open:
		_open.selected = false
		_open = null
		_update()


func _input(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if not click or not click.pressed or not _open:
		return
	var section := _sections.get(_open) as Control
	if section and not section.get_global_rect().has_point(click.position):
		close()


func _process(_delta: float) -> void:
	_update_headers()


func _rebuild() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	_headers.clear()
	_sections.clear()
	_tints.clear()
	if _open and not GameState.employees.has(_open):
		_open = null
	for e in GameState.employees:
		var employee := e as Employee
		var section := VBoxContainer.new()
		var header := Button.new()
		header.alignment = HORIZONTAL_ALIGNMENT_LEFT
		header.pressed.connect(_toggle.bind(employee))
		section.add_child(header)
		var menu := EmployeeMenu.new()
		menu.setup(employee)
		menu.task_chosen.connect(close)
		menu.name = "Menu"
		section.add_child(menu)
		add_child(section)
		_headers[employee] = header
		_sections[employee] = section
	_update()


func _toggle(employee: Employee) -> void:
	if _open == employee:
		close()
		return
	close()
	_open = employee
	employee.selected = true
	_update()
	opened.emit()


func _update() -> void:
	for e in _sections:
		(_sections[e] as Control).get_node("Menu").visible = (e == _open)
	_update_headers()


func _update_headers() -> void:
	for e in _headers:
		var employee := e as Employee
		var header := _headers[e] as Button
		var mark := "[-]" if employee == _open else "[+]"
		header.text = "%s %s" % [mark, employee.employee_name]
		header.icon = Employee.TASK_ICONS[employee.task]
		# Tâche choisie mais rien à faire : icône grisée.
		var tint := Color(1, 1, 1, 0.45) if employee.waiting else Color.WHITE
		if _tints.get(e) != tint:
			_tints[e] = tint
			for state in ["icon_normal_color", "icon_hover_color", "icon_pressed_color", "icon_focus_color"]:
				header.add_theme_color_override(state, tint)
