extends StaticBody3D

var world_data: WorldData = load("res://globals/data/world_data/world_data.tres")

@export_group("Door Data")
@export var level_scene: PackedScene
@export var level_data: LevelData

var inside: bool = false

func _ready():
	$Popup.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if inside and event.is_action_pressed("interact"):
		if level_data.is_unlocked:
			world_data.active_scene = level_scene
			world_data.spawn_point = level_data.spawn_name
			SignalBus.emit_signal("request_next")
		
func _on_area_body_entered(body: Node3D) -> void:
	inside = true
	$AnimationPlayer.play("pop_in")

func _on_area_body_exited(body: Node3D) -> void:
	inside = false
	$AnimationPlayer.play("pop_out")
