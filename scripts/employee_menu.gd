class_name EmployeeMenu
extends VBoxContainer
## Contenu du menu d'un employé : nom, statut, choix de la tâche (icônes), champ.
## Utilisé à la fois par la liste dépliable et par le menu du clic droit.

signal task_chosen ## émis quand le joueur choisit une tâche : le menu qui contient celui-ci se ferme

var employee: Employee
var _title: Label
var _status: Label
var _field_buttons: Array[Button] = []
var _task_buttons: Array[Button] = []


func setup(target: Employee) -> void:
	employee = target
	_title = _make_label(employee.employee_name, 15)
	add_child(_title)
	_status = _make_label("", 12)
	add_child(_status)

	# Une icône par tâche, nom en infobulle.
	var tasks := HBoxContainer.new()
	add_child(tasks)
	for t in Employee.TASK_NAMES.size():
		var button := Button.new()
		button.icon = Employee.TASK_ICONS[t]
		button.tooltip_text = Employee.TASK_NAMES[t]
		button.toggle_mode = true
		button.custom_minimum_size = Vector2(38, 38)
		button.pressed.connect(_on_task_pressed.bind(t))
		tasks.add_child(button)
		_task_buttons.append(button)

	var fields := HBoxContainer.new()
	add_child(fields)
	fields.add_child(_make_label("Champ :", 12))
	# Index -1 = tous les champs achetés (par défaut), sinon un seul champ.
	for i in range(-1, GameState.MAX_FIELDS):
		var button := Button.new()
		button.text = "Tous" if i == -1 else str(i + 1)
		button.tooltip_text = "Tous les champs achetes" if i == -1 else "Champ %d seulement" % (i + 1)
		button.toggle_mode = true
		button.pressed.connect(_on_field_pressed.bind(i))
		fields.add_child(button)
		_field_buttons.append(button)
	_refresh()


func _process(_delta: float) -> void:
	if is_visible_in_tree() and is_instance_valid(employee):
		_refresh()


func _on_task_pressed(task_id: int) -> void:
	employee.set_task(task_id as Employee.Task)
	_refresh()
	task_chosen.emit()


func _on_field_pressed(field_index: int) -> void:
	employee.set_work_field(field_index)
	_refresh()


func _refresh() -> void:
	_title.text = employee.employee_name
	_status.text = employee.status
	for t in _task_buttons.size():
		_task_buttons[t].set_pressed_no_signal(employee.task == t)
	for b in _field_buttons.size():
		var field_index := b - 1 # le premier bouton est "Tous" (-1)
		_field_buttons[b].set_pressed_no_signal(employee.work_field == field_index)
		_field_buttons[b].disabled = field_index >= GameState.fields_owned # champ pas encore acheté


func _make_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	return label
