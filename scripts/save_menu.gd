class_name SaveMenu
extends PanelContainer
## Menu des 3 emplacements de sauvegarde : résumé de chaque emplacement, Sauver et Charger.
## Ne touche pas aux fichiers lui-même : Main répond aux signaux (Main.save_game / Main.load_game).

signal save_requested(slot: int)
signal load_requested(slot: int)

const CONFIRM_TIME := 3.0 ## secondes pour confirmer l'écrasement d'un emplacement occupé

var _infos: Array[Label] = []
var _save_buttons: Array[Button] = []
var _load_buttons: Array[Button] = []
var _confirm_slot := -1 ## emplacement occupé en attente d'un 2e clic sur Sauver, ou -1


func _ready() -> void:
	visible = false
	custom_minimum_size = Vector2(420, 0)
	set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH

	var box := VBoxContainer.new()
	add_child(box)
	box.add_child(_make_label("PARTIE", 20))
	for slot in SaveGame.SLOT_COUNT:
		var row := HBoxContainer.new()
		box.add_child(row)
		var info := _make_label("", 13)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(info)
		_infos.append(info)
		var save := Button.new()
		save.text = "Sauver"
		save.pressed.connect(_on_save.bind(slot))
		row.add_child(save)
		_save_buttons.append(save)
		var load := Button.new()
		load.text = "Charger"
		load.pressed.connect(_on_load.bind(slot))
		row.add_child(load)
		_load_buttons.append(load)
	visibility_changed.connect(refresh)


## Relit le résumé des emplacements (à l'ouverture et après chaque sauvegarde).
func refresh() -> void:
	_confirm_slot = -1
	if not visible:
		return
	for slot in SaveGame.SLOT_COUNT:
		_save_buttons[slot].text = "Sauver"
		var info := SaveGame.info(slot)
		if info.get("exists", false):
			_infos[slot].text = "%d. %s\n    %d$, %d employe(s)" % [
				slot + 1, str(info.saved_at).replace("T", " "), info.money, info.employees]
		else:
			_infos[slot].text = "%d. (vide)" % (slot + 1)
		_load_buttons[slot].disabled = not info.get("exists", false)


## Un emplacement occupé demande un 2e clic dans les CONFIRM_TIME secondes avant d'être écrasé.
func _on_save(slot: int) -> void:
	if SaveGame.exists(slot) and _confirm_slot != slot:
		refresh()
		_confirm_slot = slot
		_save_buttons[slot].text = "Ecraser ?"
		get_tree().create_timer(CONFIRM_TIME).timeout.connect(_cancel_confirm.bind(slot))
		return
	save_requested.emit(slot)
	refresh()


func _cancel_confirm(slot: int) -> void:
	if _confirm_slot == slot:
		refresh()


func _on_load(slot: int) -> void:
	load_requested.emit(slot)
	UiAnim.disappear(self)


func _make_label(text: String, font_size: int) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	return label
