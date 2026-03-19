@tool
extends Label

@export var world_data: WorldData

func _process(delta: float) -> void:
	if not world_data:
		printerr("Error (File): missing world data import.")
		
	if world_data and world_data.active_scene:
		text = world_data.spawn_point
	else:
		text = "No spawn point set."
