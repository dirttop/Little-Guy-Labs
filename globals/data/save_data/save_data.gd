class_name SaveData extends Resource

@export var levels: Array[LevelData] = []

func get_level_data(target_id: String) -> LevelData:
	for level in levels:
		if level.level_id == target_id:
			return level
			
	printerr("Error (Load): Level ID not found in save data: " + target_id)
	return null
