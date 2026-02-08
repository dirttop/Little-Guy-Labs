@tool
extends EditorPlugin

var dock

func _enter_tree() -> void:
	dock = preload("res://addons/set_scene/set_scene.tscn").instantiate()
	var button = dock.get_node("Margin/VBox/Margin/Button")
	button.pressed.connect(_on_set_pressed)

	add_control_to_bottom_panel(dock, "Set Scene")

func _exit_tree() -> void:
	remove_control_from_bottom_panel(dock)
	dock.free()

func _on_set_pressed():
	var editor_interface = get_editor_interface()
	if not editor_interface:
		printerr("Error (Tool): editor interace not found.")
		return
		
	var scene_root = editor_interface.get_edited_scene_root()
	if not scene_root:
		printerr("Error (Tool): no scene is currently open in the editor.")
		return
	
	var data_path = "res://globals/data/world_data/world_data.tres"
	var world_data = load("res://globals/data/world_data/world_data.tres") as WorldData

	if world_data:
		var scene_path = scene_root.scene_file_path
		world_data.active_scene = load(scene_path)
		
		var spawn_input = dock.get_node("Margin/VBox/SpawnInput")
		if spawn_input:
			world_data.spawn_point = spawn_input.text
			
		ResourceSaver.save(world_data, data_path)
		print("Set '", scene_path, "' to the WorldData resource with target spawn point: ", world_data.spawn_point)
	else:
		printerr("Error (Tool): could not set active scene in WorldData")
