extends Node

const save_dir := "res://tools/test/saves/" 

var world_data: WorldData = load("res://globals/data/world_data/world_data.tres")
@export var new_game_scene: PackedScene
@export var new_game_spawn: String

var current_save: SaveData
var current_slot: int = 1

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(save_dir):
		DirAccess.make_dir_recursive_absolute(save_dir)

func get_save_path(slot_id: int) -> String:
	return save_dir + "save_" + str(slot_id) + ".res"

func save_game(slot_id: int = current_slot):
	if current_save:
		current_save.last_scene = world_data.active_scene
		current_save.last_spawn = world_data.spawn_point
		set_artifact_count(slot_id)
		
		SignalBus.emit_signal("saving")
		var save = ResourceSaver.save(current_save, get_save_path(slot_id))
		
		if save == OK:
			current_slot = slot_id
			SignalBus.emit_signal("saved")
		else:
			printerr("Error (Save): ", save)

func load_save(slot_id: int):
	var path := get_save_path(slot_id)
	current_slot = slot_id
	print("loading save")
	if ResourceLoader.exists(path):
		print("here")
		current_save = ResourceLoader.load(path) as SaveData
		load_game()
	else:
		current_save = SaveData.new()
		load_new_game()
		print("loading new game")

func load_game():
	world_data.active_scene = current_save.last_scene
	world_data.spawn_point = current_save.last_spawn
	SignalBus.emit_signal("request_next")

func load_new_game():
	world_data.active_scene = new_game_scene
	world_data.spawn_point = new_game_spawn
	SignalBus.emit_signal("request_next")

func has_save(slot_id: int) -> bool:
	return ResourceLoader.exists(get_save_path(slot_id))

func get_level_data(target_id: String) -> LevelData:
	if current_save: #not sure how I feel about this implement. 
		#gives more flex for id naming but could hit performance
		for level in current_save.levels:
			if level.level_id == target_id:
				return level
				
	printerr("Error (Load): Level ID not found in save data: " + target_id)
	return null
	
func get_data(slot_id: int) -> Dictionary:
	var path := get_save_path(slot_id)
	
	if ResourceLoader.exists(path):
		var data = ResourceLoader.load(path) as SaveData
		if data:
			return {
				"playtime": data.playtime,
				"artifact_count": data.artifact_count,
				"section": data.section
			}
		
	return {}

func set_artifact_count(slot_id: int):
	var total = 0
	for i in current_save.levels:
		total += i.collectible_count
	current_save.artifact_count = total

func update_playtime(added_time: float):
	current_save.playtime += added_time
