extends Area3D

var world_data: WorldData = load("res://globals/data/world_data/world_data.tres")

@export_group("Settings")
@export var next_scene: PackedScene
@export var next_spawn: String

func _on_body_entered(body: Node3D) -> void:
	world_data.active_scene = next_scene
	world_data.spawn_point = next_spawn
	SignalBus.emit_signal("request_next")
