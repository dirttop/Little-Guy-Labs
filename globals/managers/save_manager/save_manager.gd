extends Node

const save_dir := "res://tools/test/saves/" 

var current_save: SaveData
var current_slot: int = 1

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(save_dir):
		DirAccess.make_dir_recursive_absolute(save_dir)

func get_save_path(slot_id: int) -> String:
	return save_dir + "save_" + str(slot_id) + ".res"

func save_game(slot_id: int = current_slot) -> void:
	if current_save:
		var path := get_save_path(slot_id)
		var error := ResourceSaver.save(current_save, path)
		
		if error == OK:
			current_slot = slot_id
		else:
			printerr("Error (Save): ", error)

func load_save(slot_id: int) -> void:
	var path := get_save_path(slot_id)
	current_slot = slot_id
	
	if ResourceLoader.exists(path):
		current_save = ResourceLoader.load(path) as SaveData
	else:
		current_save = SaveData.new()

func has_save(slot_id: int) -> bool:
	return ResourceLoader.exists(get_save_path(slot_id))
