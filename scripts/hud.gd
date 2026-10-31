class_name Hud
extends CanvasLayer
## Interface : argent et inventaire (bas gauche), aide des touches (haut gauche),
## liste des employés (colonne de droite), marché.

const ICON_COIN := preload("res://assets/sprites/icon_coin.png")
const ICON_SEEDS := preload("res://assets/sprites/icon_seeds.png")
const ICON_WHEAT := preload("res://assets/sprites/icon_wheat.png")
const ICON_MARKET := preload("res://assets/sprites/icon_market.png")
const ICON_SCALE := 2 ## les icônes 16x16 sont affichées en 32x32

var _money: Label
var _seeds: Label
var _wheat: Label
var _help: Label
var _market: MarketMenu
var _market_button: Button
var _employee_list: EmployeeList
var _employee_popup: EmployeePopup


func _ready() -> void:
	# Argent, graines et blé en bas à gauche, sur une ligne.
	var stats := HBoxContainer.new()
	stats.add_theme_constant_override("separation", 10)
	add_child(stats)
	_money = _add_stat(stats, ICON_COIN)
	_seeds = _add_stat(stats, ICON_SEEDS)
	_wheat = _add_stat(stats, ICON_WHEAT)

	_help = _make_label(self, 13)
	_help.position = Vector2(12, 8)
	_help.text = "ZQSD/WASD/fleches : bouger\nE/Espace : agir sur la case visee (recolter, arroser, planter)\nF : interagir (boite de vente)\nB : marche (achats, revente)\nClic droit sur un employe : son menu"
	GameState.changed.connect(_refresh)
	_refresh()
	stats.grow_vertical = Control.GROW_DIRECTION_BEGIN
	stats.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT, Control.PRESET_MODE_MINSIZE, 12)

	_employee_list = EmployeeList.new()
	add_child(_employee_list)
	_employee_popup = EmployeePopup.new()
	add_child(_employee_popup)
	# Un seul menu d'employé ouvert à la fois.
	_employee_list.opened.connect(_employee_popup.close)
	_employee_popup.opened.connect(_employee_list.close)

	_market = MarketMenu.new()
	add_child(_market)
	_market_button = Button.new()
	_market_button.text = "Marche [B]"
	_market_button.icon = ICON_MARKET
	_market_button.pressed.connect(_toggle_market)
	add_child(_market_button)
	_market_button.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_MINSIZE, 12)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("market"):
		_toggle_market()
	elif event.is_action_pressed("ui_cancel") and _market.visible:
		_market.visible = false


# Cliquer en dehors du marché le ferme (le bouton du HUD gère son propre basculement).
func _input(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if click and click.pressed and _market.visible:
		if not _market.get_global_rect().has_point(click.position) \
				and not _market_button.get_global_rect().has_point(click.position):
			_market.visible = false


func _toggle_market() -> void:
	_market.visible = not _market.visible


func _add_stat(parent: Control, icon: Texture2D) -> Label:
	_make_icon(parent, icon)
	var label := _make_label(parent, 20)
	label.add_theme_constant_override("outline_size", 4)
	return label


func _make_icon(parent: Control, texture: Texture2D) -> TextureRect:
	var icon := TextureRect.new()
	icon.texture = texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = texture.get_size() * ICON_SCALE
	parent.add_child(icon)
	return icon


func _make_label(parent: Node, font_size: int) -> Label:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	parent.add_child(label)
	return label


func _refresh() -> void:
	_money.text = "%d$" % GameState.money
	_seeds.text = "%d" % GameState.seeds
	_wheat.text = "%d" % GameState.wheat
