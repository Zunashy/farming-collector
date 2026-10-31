class_name CharacterSprite
extends Sprite2D
## Personnage animé à partir d'une spritesheet 4x4 (cellules 16x32).
## Lignes : bas, haut, gauche, droite. Colonnes : repos, pas gauche, transition, pas droit.
## Les pieds sont posés sur l'origine du parent + 8 px, quelle que soit l'échelle.

## Agrandi pour que les personnages ne se perdent pas dans les champs. Avec le zoom x2 de la caméra,
## x1.5 donne exactement 3 pixels d'écran par pixel de sprite : les pixels restent nets.
const SPRITE_SCALE := 1.5
const WALK_FRAMES: Array[int] = [1, 2, 3, 2]
const WALK_FPS := 8.0

var _row := 0
var _moving := false
var _time := 0.0


func _init(sheet: Texture2D = null) -> void:
	texture = sheet
	hframes = 4
	vframes = 4
	offset = Vector2(0, -8)
	scale = Vector2(SPRITE_SCALE, SPRITE_SCALE)
	position = Vector2(0, 8.0 - 8.0 * SPRITE_SCALE)


## Oriente le personnage vers dir (l'axe dominant l'emporte).
func set_facing(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return
	if absf(dir.x) > absf(dir.y):
		_row = 2 if dir.x < 0 else 3
	else:
		_row = 1 if dir.y < 0 else 0


func set_moving(value: bool) -> void:
	_moving = value


func _process(delta: float) -> void:
	var col := 0
	if _moving:
		_time += delta
		col = WALK_FRAMES[int(_time * WALK_FPS) % WALK_FRAMES.size()]
	else:
		_time = 0.0
	frame = _row * 4 + col
