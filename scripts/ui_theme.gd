class_name UiTheme
extends RefCounted
## Thème des menus : boutons blancs à texte noir, panneaux crème bordés de bois.
## Appliqué par le HUD aux menus et aux boutons, pas aux textes posés sur le jeu (argent, aide, messages).

const INK := Color(0.1, 0.08, 0.06) ## texte
const INK_DISABLED := Color(0.1, 0.08, 0.06, 0.4)
const BUTTON := Color(1, 1, 1)
const BUTTON_HOVER := Color(0.93, 0.93, 0.93)
const BUTTON_DOWN := Color(0.84, 0.84, 0.84)
const BUTTON_DISABLED := Color(0.95, 0.95, 0.95, 0.85)
const BUTTON_BORDER := Color(0.72, 0.66, 0.58)
const SELECTED := Color(1.0, 0.86, 0.55) ## bouton à bascule enfoncé (tâche ou champ choisi)
const SELECTED_BORDER := Color(0.75, 0.52, 0.2)
const PANEL := Color(0.99, 0.97, 0.92)
const PANEL_BORDER := Color(0.45, 0.3, 0.17)


static func build() -> Theme:
	var theme := Theme.new()
	theme.set_stylebox("normal", "Button", _box(BUTTON, BUTTON_BORDER))
	theme.set_stylebox("hover", "Button", _box(BUTTON_HOVER, BUTTON_BORDER))
	theme.set_stylebox("pressed", "Button", _box(SELECTED, SELECTED_BORDER))
	theme.set_stylebox("hover_pressed", "Button", _box(SELECTED.darkened(0.06), SELECTED_BORDER))
	theme.set_stylebox("disabled", "Button", _box(BUTTON_DISABLED, BUTTON_BORDER.lerp(Color.WHITE, 0.5)))
	theme.set_stylebox("focus", "Button", StyleBoxEmpty.new())
	for state in ["font_color", "font_hover_color", "font_pressed_color", "font_hover_pressed_color", "font_focus_color"]:
		theme.set_color(state, "Button", INK)
	theme.set_color("font_disabled_color", "Button", INK_DISABLED)
	theme.set_color("icon_disabled_color", "Button", Color(1, 1, 1, 0.4))

	var panel := _box(PANEL, PANEL_BORDER, 10, 2)
	panel.set_content_margin_all(12)
	panel.shadow_color = Color(0, 0, 0, 0.3)
	panel.shadow_size = 6
	panel.shadow_offset = Vector2(0, 3)
	theme.set_stylebox("panel", "PanelContainer", panel)

	theme.set_color("font_color", "Label", INK)

	theme.set_stylebox("normal", "LineEdit", _box(BUTTON, BUTTON_BORDER))
	theme.set_stylebox("focus", "LineEdit", _box(BUTTON, SELECTED_BORDER))
	theme.set_color("font_color", "LineEdit", INK)
	theme.set_color("caret_color", "LineEdit", INK)
	theme.set_color("selection_color", "LineEdit", SELECTED)
	# Flèches de la case de quantité : sombres, sinon blanches sur blanc.
	for arrow in ["up", "down"]:
		for state in ["", "_hover", "_pressed"]:
			theme.set_color("%s%s_icon_modulate" % [arrow, state], "SpinBox", INK)
	return theme


static func _box(fill: Color, border: Color, radius := 6, border_width := 1) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(border_width)
	box.set_corner_radius_all(radius)
	box.content_margin_left = 10
	box.content_margin_right = 10
	box.content_margin_top = 5
	box.content_margin_bottom = 5
	return box
