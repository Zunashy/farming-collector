class_name Hud
extends CanvasLayer
## Interface : argent et inventaire (bas gauche), aide des touches (haut gauche),
## liste des employés (colonne de droite), marché.

const ICON_COIN := preload("res://assets/pack_v2/icon_coin.png")
const ICON_SEEDS := preload("res://assets/pack_v2/icon_seeds.png")
const ICON_WHEAT := preload("res://assets/pack_v2/icon_wheat.png")
const ICON_MARKET := preload("res://assets/pack_v2/icon_market.png")
const ICON_SCALE := 2 ## les icônes 16x16 sont affichées en 32x32
const TOAST_TIME := 2.5 ## durée d'affichage d'un message (secondes), fondu compris

var _toast: Label
var _toast_tween: Tween
var _money: Label
var _seeds: Label
var _wheat: Label
var _help: Label
var _market: MarketMenu
var _market_button: Button
var save_menu: SaveMenu ## Main se branche sur ses signaux
var _save_button: Button
var _employee_list: EmployeeList
var _employee_popup: EmployeePopup


func _ready() -> void:
	# Les boutons du HUD (y compris ceux créés plus tard) ne prennent jamais le focus clavier :
	# sinon Espace (agir) réactiverait le dernier bouton cliqué. Retirer le focus après coup
	# ne convient pas : un bouton qui perd le focus pendant l'appui annule le clic.
	get_tree().node_added.connect(_on_node_added)
	# Argent, graines et blé en bas à gauche, sur une ligne.
	var stats := HBoxContainer.new()
	stats.add_theme_constant_override("separation", 10)
	add_child(stats)
	_money = _add_stat(stats, ICON_COIN)
	_seeds = _add_stat(stats, ICON_SEEDS)
	_wheat = _add_stat(stats, ICON_WHEAT)

	_help = _make_label(self, 13)
	_help.position = Vector2(12, 8)
	_help.text = "ZQSD/WASD/fleches : bouger\nE/Espace : agir sur la case visee (recolter, arroser, planter)\nF : interagir (boite de vente)\nB : marche (achats, revente)\nEchap : partie (sauver, charger)\nClic droit sur un employe : son menu"
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

	save_menu = SaveMenu.new()
	add_child(save_menu)
	_save_button = Button.new()
	_save_button.text = "Partie [Echap]"
	_save_button.pressed.connect(_toggle_save_menu)
	add_child(_save_button)
	# Au-dessus du bouton du marché.
	_save_button.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT, Control.PRESET_MODE_MINSIZE, 12)
	_save_button.offset_top -= _market_button.size.y + 8
	_save_button.offset_bottom -= _market_button.size.y + 8

	# Messages au centre, en bas de l'écran.
	_toast = _make_label(self, 16)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	_toast.offset_left = -300
	_toast.offset_right = 300
	_toast.offset_top = -90
	_toast.offset_bottom = -60
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	GameState.notified.connect(_show_toast)

	# Thème des menus (boutons blancs, texte noir) ; les textes posés sur le jeu gardent leur style.
	var theme := UiTheme.build()
	for menu: Control in [_employee_list, _employee_popup, _market, _market_button, save_menu, _save_button]:
		menu.theme = theme


func _on_node_added(node: Node) -> void:
	if node is BaseButton and is_ancestor_of(node):
		(node as BaseButton).focus_mode = Control.FOCUS_NONE


func _show_toast(text: String) -> void:
	_toast.text = text
	if _toast_tween:
		_toast_tween.kill()
	_toast.modulate.a = 1.0
	_toast_tween = create_tween()
	_toast_tween.tween_interval(TOAST_TIME - 0.5)
	_toast_tween.tween_property(_toast, "modulate:a", 0.0, 0.5)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("market"):
		_toggle_market()
	elif event.is_action_pressed("ui_cancel"):
		# Échap ferme le marché s'il est ouvert, sinon ouvre ou ferme le menu de la partie.
		if UiAnim.is_shown(_market):
			UiAnim.disappear(_market)
		else:
			_toggle_save_menu()


# Cliquer en dehors d'un menu le ferme (les boutons du HUD gèrent leur propre basculement).
func _input(event: InputEvent) -> void:
	var click := event as InputEventMouseButton
	if not click or not click.pressed:
		return
	if UiAnim.is_shown(_market) and not _market.get_global_rect().has_point(click.position) \
			and not _market_button.get_global_rect().has_point(click.position):
		UiAnim.disappear(_market)
	if UiAnim.is_shown(save_menu) and not save_menu.get_global_rect().has_point(click.position) \
			and not _save_button.get_global_rect().has_point(click.position):
		UiAnim.disappear(save_menu)


func _toggle_market() -> void:
	UiAnim.toggle(_market)
	UiAnim.disappear(save_menu)


func _toggle_save_menu() -> void:
	UiAnim.toggle(save_menu)
	UiAnim.disappear(_market)


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
