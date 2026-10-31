class_name DayNight
extends CanvasModulate
## Cycle jour / nuit, pour l'instant purement décoratif : seule la lumière du monde change (pas le HUD).
## Jour, crépuscule, nuit, aube, puis on recommence. Aucun effet sur le jeu.

const DAY_TIME := 240.0
const DUSK_TIME := 20.0
const NIGHT_TIME := 90.0
const DAWN_TIME := 20.0
const DAY_LIGHT := Color(1.0, 0.95, 0.86) ## fin d'après-midi chaude
const DUSK_LIGHT := Color(0.95, 0.68, 0.55)
const NIGHT_LIGHT := Color(0.38, 0.42, 0.62)

var time := 0.0 ## secondes écoulées depuis le début du cycle en cours (0 = début du jour)


func _ready() -> void:
	color = DAY_LIGHT


func _process(delta: float) -> void:
	time = fmod(time + delta, DAY_TIME + DUSK_TIME + NIGHT_TIME + DAWN_TIME)
	color = _light_at(time)


func _light_at(t: float) -> Color:
	if t < DAY_TIME:
		return DAY_LIGHT
	t -= DAY_TIME
	if t < DUSK_TIME: # coucher : la lumière rougit puis bleuit
		var k := t / DUSK_TIME
		return DAY_LIGHT.lerp(DUSK_LIGHT, k * 2.0) if k < 0.5 else DUSK_LIGHT.lerp(NIGHT_LIGHT, k * 2.0 - 1.0)
	t -= DUSK_TIME
	if t < NIGHT_TIME:
		return NIGHT_LIGHT
	t -= NIGHT_TIME
	return NIGHT_LIGHT.lerp(DAY_LIGHT, t / DAWN_TIME)
