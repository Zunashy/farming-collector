class_name MarketMenu
extends PanelContainer
## Menu d'achat et de revente : graines, employés, champs. Touche B ou bouton du HUD.

const ICON_SEEDS := preload("res://assets/sprites/icon_seeds.png")

var _seed_buy: Button
var _employee_buy: Button
var _field_buy: Button
var _seed_sell: Button
var _employee_sales: VBoxContainer


func _ready() -> void:
	visible = false
	custom_minimum_size = Vector2(340, 0)
	set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH

	var box := VBoxContainer.new()
	add_child(box)
	box.add_child(_make_label("MARCHE", 20))
	box.add_child(_make_label("Achat", 15))
	_seed_buy = _make_button(box, GameState.buy_seed)
	_seed_buy.icon = ICON_SEEDS
	_employee_buy = _make_button(box, GameState.buy_employee)
	_field_buy = _make_button(box, GameState.buy_field)
	box.add_child(_make_label("Revente", 15))
	_seed_sell = _make_button(box, GameState.sell_seed)
	_seed_sell.icon = ICON_SEEDS
	_employee_sales = VBoxContainer.new()
	box.add_child(_employee_sales)

	GameState.changed.connect(_refresh)
	GameState.employees_changed.connect(_rebuild_sales)
	_rebuild_sales()
	_refresh()


func _refresh() -> void:
	var money := GameState.money
	_seed_buy.text = "Graine de ble (%d$)" % GameState.SEED_PRICE
	_seed_buy.disabled = money < GameState.SEED_PRICE

	var hired := GameState.employees.size()
	var text := "Employe (%d$)  [%d/%d]" % [GameState.EMPLOYEE_PRICE, hired, GameState.MAX_EMPLOYEES]
	if hired < GameState.MAX_EMPLOYEES and GameState.free_field_slot() == -1:
		text += " - achete un champ"
	_employee_buy.text = text
	_employee_buy.disabled = not GameState.can_hire() or money < GameState.EMPLOYEE_PRICE

	var field_price := GameState.next_field_price()
	if field_price < 0:
		_field_buy.text = "Tous les champs sont achetes"
		_field_buy.disabled = true
	else:
		_field_buy.text = "Champ %d (%d$)" % [GameState.fields_owned + 1, field_price]
		_field_buy.disabled = money < field_price

	_seed_sell.text = "Vendre une graine (+%d$)  [%d]" % [GameState.SEED_SELL_PRICE, GameState.seeds]
	_seed_sell.disabled = GameState.seeds <= 0


func _rebuild_sales() -> void:
	for child in _employee_sales.get_children():
		_employee_sales.remove_child(child)
		child.queue_free()
	for e in GameState.employees:
		var button := Button.new()
		button.text = "Revendre %s (+%d$)" % [e.employee_name, GameState.EMPLOYEE_SELL_PRICE]
		button.pressed.connect(GameState.sell_employee.bind(e))
		_employee_sales.add_child(button)
	_refresh()


func _make_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _make_button(parent: Control, on_pressed: Callable) -> Button:
	var button := Button.new()
	button.pressed.connect(on_pressed)
	parent.add_child(button)
	return button
