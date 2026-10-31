class_name MarketMenu
extends PanelContainer
## Menu d'achat et de revente : graines, employés, champs. Touche B ou bouton du HUD.

const ICON_SEEDS := preload("res://assets/sprites/icon_seeds.png")
## Touches qui servent à saisir la quantité ; toute autre touche rend la main au jeu.
const EDIT_KEYS: Array[Key] = [KEY_BACKSPACE, KEY_DELETE, KEY_LEFT, KEY_RIGHT, KEY_HOME, KEY_END, KEY_UP, KEY_DOWN]

var _seed_count: SpinBox
var _seed_total: Label
var _seed_buy: Button
var _seed_buy_max: Button
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
	_build_seed_purchase(box)
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


## Graines : quantité, prix total, « Acheter » et « Acheter le maximum ».
func _build_seed_purchase(box: VBoxContainer) -> void:
	var title := _make_label("Graines de ble (%d$ piece)" % GameState.SEED_PRICE, 13)
	box.add_child(title)
	var row := HBoxContainer.new()
	box.add_child(row)
	_seed_count = SpinBox.new()
	_seed_count.min_value = 1
	_seed_count.value = 1
	_seed_count.select_all_on_focus = true
	_seed_count.value_changed.connect(_on_seed_count_changed)
	# Entrée valide la saisie et rend la main au jeu (sinon E et Espace s'écriraient dans la case).
	_seed_count.get_line_edit().text_submitted.connect(func(_t: String) -> void: _seed_count.get_line_edit().release_focus())
	row.add_child(_seed_count)
	_seed_total = _make_label("", 13)
	_seed_total.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_seed_total)
	_seed_buy = _make_button(row, func() -> void: GameState.buy_seeds(int(_seed_count.value)))
	_seed_buy.icon = ICON_SEEDS
	_seed_buy.text = "Acheter"
	_seed_buy_max = _make_button(box, func() -> void: GameState.buy_seeds(GameState.max_affordable_seeds()))


# Pendant la saisie de la quantité, E, Espace ou ZQSD valident la saisie et repartent vers le jeu.
func _input(event: InputEvent) -> void:
	var key := event as InputEventKey
	var line := _seed_count.get_line_edit()
	if not key or not key.pressed or not line.has_focus():
		return
	var is_digit := key.unicode >= KEY_0 and key.unicode <= KEY_9
	if not is_digit and not EDIT_KEYS.has(key.keycode):
		line.release_focus() # la SpinBox applique la valeur tapée en perdant le focus


func _on_seed_count_changed(_value: float) -> void:
	_refresh_seed_purchase()


func _refresh_seed_purchase() -> void:
	var affordable := GameState.max_affordable_seeds()
	# La quantité ne peut pas dépasser le budget ; au moins 1 pour garder le champ lisible.
	_seed_count.max_value = maxi(affordable, 1)
	var count := int(_seed_count.value)
	_seed_total.text = "Total : %d$" % (count * GameState.SEED_PRICE)
	_seed_buy.disabled = count > affordable
	_seed_buy_max.text = "Acheter le maximum (%d pour %d$)" % [affordable, affordable * GameState.SEED_PRICE]
	_seed_buy_max.disabled = affordable <= 0


func _refresh() -> void:
	var money := GameState.money
	_refresh_seed_purchase()

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
