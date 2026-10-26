class_name Hud
extends CanvasLayer
## Interface : argent, inventaire, barre d'outils, aide des touches.

var _stats: Label
var _tools: Label
var _help: Label


func _ready() -> void:
	_stats = _make_label(Vector2(12, 8), 20)
	_tools = _make_label(Vector2(12, 500), 20)
	_help = _make_label(Vector2(560, 8), 13)
	_help.text = "ZQSD/WASD/fleches : bouger\nE/Espace : utiliser l'outil\n1-2-3 / molette : changer d'outil\nF : interagir (boite, boutique)"
	GameState.changed.connect(_refresh)
	_refresh()


func _make_label(pos: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.position = pos
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	add_child(label)
	return label


func _refresh() -> void:
	_stats.text = "Argent : %d$    Graines : %d    Ble : %d" % [GameState.money, GameState.seeds, GameState.wheat]
	var parts: Array[String] = []
	for i in GameState.TOOL_NAMES.size():
		var tool_name := GameState.TOOL_NAMES[i]
		parts.append(("> %d %s <" if i == GameState.current_tool else "  %d %s  ") % [i + 1, tool_name])
	_tools.text = "".join(parts)
