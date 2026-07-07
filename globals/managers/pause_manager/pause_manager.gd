extends Node

var paused = false
var path_to_pause_menu = "/root/World/UI/PauseMenu"

func _input(_event: InputEvent) -> void:
	print("ASDF")
	if Input.is_action_just_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	paused = not paused
	get_tree().paused = paused
	var menu = get_node(path_to_pause_menu)
	menu.visible = not menu.visible
