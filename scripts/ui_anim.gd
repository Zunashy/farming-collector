class_name UiAnim
extends RefCounted
## Ouverture et fermeture animées des menus : léger zoom avec rebond et fondu.
## Utiliser set_shown / is_shown plutôt que `visible` pour les menus animés : pendant la fermeture,
## le menu est encore visible mais déjà considéré comme fermé.

const OPEN_TIME := 0.16
const CLOSE_TIME := 0.1
const SMALL := Vector2(0.9, 0.9) ## échelle de départ (ouverture) et d'arrivée (fermeture)


## Vrai si le menu est ouvert ou en train de s'ouvrir.
static func is_shown(control: Control) -> bool:
	return control.get_meta("ui_shown", control.visible)


static func set_shown(control: Control, shown: bool, on_hidden := Callable()) -> void:
	if shown:
		appear(control)
	else:
		disappear(control, on_hidden)


static func toggle(control: Control) -> void:
	set_shown(control, not is_shown(control))


static func appear(control: Control) -> void:
	if is_shown(control) and control.visible:
		return
	control.set_meta("ui_shown", true)
	var tween := _restart(control)
	control.visible = true
	control.pivot_offset = control.size / 2.0
	control.modulate.a = 0.0
	control.scale = SMALL
	tween.set_parallel(true)
	tween.tween_property(control, "modulate:a", 1.0, OPEN_TIME)
	tween.tween_property(control, "scale", Vector2.ONE, OPEN_TIME).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Ferme le menu, puis appelle on_hidden une fois l'animation finie (s'il est fourni).
static func disappear(control: Control, on_hidden := Callable()) -> void:
	if not is_shown(control):
		return
	control.set_meta("ui_shown", false)
	if not control.visible or not control.is_inside_tree():
		control.visible = false
		if on_hidden.is_valid():
			on_hidden.call()
		return
	var tween := _restart(control)
	control.pivot_offset = control.size / 2.0
	tween.set_parallel(true)
	tween.tween_property(control, "modulate:a", 0.0, CLOSE_TIME)
	tween.tween_property(control, "scale", SMALL, CLOSE_TIME).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func() -> void:
		control.visible = false
		control.scale = Vector2.ONE
		control.modulate.a = 1.0
		if on_hidden.is_valid():
			on_hidden.call())


## Arrête l'animation en cours du menu et en crée une nouvelle.
static func _restart(control: Control) -> Tween:
	if control.has_meta("ui_tween"):
		var previous: Tween = control.get_meta("ui_tween")
		if previous and previous.is_valid():
			previous.kill()
	var tween := control.create_tween()
	control.set_meta("ui_tween", tween)
	return tween
