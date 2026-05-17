extends StaticBody3D

@export_group("Artifact Data")
@export var artifact_index: int = 0
@export var level_data: LevelData

@export_group("Artifact Settings")
@export var artifact_mesh: Mesh
@export var main_artifact: bool = false
@export var hub_spawn: String = ""

var rotation_speed = 1

func _ready() -> void:
	SignalBus.connect("next_ready", Callable(self, "_on_level_start"))
	SignalBus.connect("load_next", Callable(self, "_on_level_exit"))
	$AnimationPlayer.play("RESET")
	#gleb: I am not crazy
	#we get an error otherwise because the spawn changes before it's actually 'ready'
	#if you have questions take it up with my world management system

func _on_level_start():
	if main_artifact:
		var world_data: WorldData = load("res://globals/data/world_data/world_data.tres")
		world_data.active_scene = load("res://screens/world/scenes/hub/hub.tscn")
		world_data.spawn_point = hub_spawn

func _process(delta: float) -> void:
	$Mesh.rotate_y(rotation_speed*delta)

func _on_area_body_entered(body: Node3D) -> void:
	SignalBus.emit_signal("artifact_collected", artifact_index)
	rotation_speed = 5
	$AnimationPlayer.play("collect")
	
	if main_artifact:
		_end_level()
	else:
		_update_data()
		
	await $AnimationPlayer.animation_finished
	if !main_artifact:
		queue_free()
		
func _update_data():
	level_data.artifacts[artifact_index] = true
	level_data.artifact_count += 1

func _end_level():
	level_data.is_completed = true
	SignalBus.emit_signal("request_next")

func _on_level_exit():
	SignalBus.emit_signal("exit_level")
	
