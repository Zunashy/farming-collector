class_name SaveGame
extends RefCounted
## Sauvegarde sur 3 emplacements : user://saves/slot_1.json à slot_3.json (les emplacements sont numérotés
## de 0 à 2 dans le code). Fichiers JSON lisibles, avec un numéro de version pour les migrations futures.
## Pas encore branché au jeu : voir Main.save_game / Main.load_game.

const SLOT_COUNT := 3
const VERSION := 1
const DIR := "user://saves"


static func is_valid_slot(slot: int) -> bool:
	return slot >= 0 and slot < SLOT_COUNT


static func slot_path(slot: int) -> String:
	return "%s/slot_%d.json" % [DIR, slot + 1]


static func exists(slot: int) -> bool:
	return is_valid_slot(slot) and FileAccess.file_exists(slot_path(slot))


## Écrit l'état dans l'emplacement. On écrit d'abord un fichier temporaire pour ne jamais laisser
## une sauvegarde à moitié écrite si le jeu plante pendant l'écriture.
static func write(slot: int, state: Dictionary) -> bool:
	if not is_valid_slot(slot):
		push_error("SaveGame : emplacement invalide (%d)" % slot)
		return false
	DirAccess.make_dir_recursive_absolute(DIR)
	var envelope := {
		"version": VERSION,
		"saved_at": Time.get_datetime_string_from_system(),
		"state": state,
	}
	var path := slot_path(slot)
	var tmp_path := path + ".tmp"
	var file := FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		push_error("SaveGame : écriture impossible (%s)" % error_string(FileAccess.get_open_error()))
		return false
	file.store_string(JSON.stringify(envelope, "\t"))
	file.close()
	var err := DirAccess.rename_absolute(tmp_path, path)
	if err != OK:
		push_error("SaveGame : renommage impossible (%s)" % error_string(err))
		return false
	return true


## L'état sauvegardé, ou {} si l'emplacement est vide, illisible ou issu d'une version plus récente.
static func read(slot: int) -> Dictionary:
	var envelope := _read_envelope(slot)
	if envelope.is_empty():
		return {}
	if int(envelope.get("version", 0)) > VERSION:
		push_warning("SaveGame : l'emplacement %d vient d'une version plus récente du jeu." % (slot + 1))
		return {}
	var state: Variant = envelope.get("state", {})
	return state if typeof(state) == TYPE_DICTIONARY else {}


## Résumé pour un futur écran de choix : {"exists", "saved_at", "money", "employees"}.
static func info(slot: int) -> Dictionary:
	var envelope := _read_envelope(slot)
	if envelope.is_empty():
		return {"exists": false}
	var state: Dictionary = read(slot)
	var game: Dictionary = state.get("game", {})
	var employees: Array = state.get("employees", [])
	return {
		"exists": true,
		"saved_at": str(envelope.get("saved_at", "")),
		"money": int(game.get("money", 0)),
		"employees": employees.size(),
	}


static func delete(slot: int) -> void:
	if exists(slot):
		DirAccess.remove_absolute(slot_path(slot))


static func _read_envelope(slot: int) -> Dictionary:
	if not exists(slot):
		return {}
	var file := FileAccess.open(slot_path(slot), FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("SaveGame : l'emplacement %d est illisible." % (slot + 1))
		return {}
	return parsed
