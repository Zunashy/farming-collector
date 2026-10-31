class_name EmployeePopup
extends PanelContainer
## Menu d'un employé ouvert par clic droit sur lui. Suit l'employé ; un clic en dehors le ferme.

signal opened

var _employee: Employee


func _ready() -> void:
	visible = false
	GameState.employee_menu_requested.connect(open_for)


func open_for(employee: Employee) -> void:
	_deselect()
	_clear()
	_employee = employee
	employee.selected = true
	var menu := EmployeeMenu.new()
	menu.setup(employee)
	menu.task_chosen.connect(close)
	add_child(menu)
	reset_size()
	_follow()
	UiAnim.appear(self)
	opened.emit()


## Ferme le menu ; son contenu est retiré une fois l'animation de fermeture finie.
func close() -> void:
	_deselect()
	UiAnim.disappear(self, _clear)


func _deselect() -> void:
	if is_instance_valid(_employee):
		_employee.selected = false
	_employee = null


func _clear() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


func _input(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if UiAnim.is_shown(self) and click and click.pressed and not get_global_rect().has_point(click.position):
		close()


func _process(_delta: float) -> void:
	if not UiAnim.is_shown(self):
		return
	if not is_instance_valid(_employee) or not GameState.employees.has(_employee):
		close()
		return
	_follow()


func _follow() -> void:
	var anchor := _employee.get_global_transform_with_canvas().origin + Vector2(20, -50)
	var limit := get_viewport_rect().size - size
	position = anchor.clamp(Vector2.ZERO, limit.max(Vector2.ZERO))
