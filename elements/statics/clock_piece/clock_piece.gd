extends StaticBody3D

@export_group("Level Data")
@export var level_data: LevelData

@export_group("Settings")
@export var mesh: Mesh
@export var hub_spawn: String = ""

var world_data: WorldData

var rotation_speed = 1

func _ready() -> void:
	#SignalBus.connect("next_ready", Callable(self, "_on_level_start"))
	SignalBus.connect("load_next", _on_level_exit)
	$AnimationPlayer.play("RESET")
	#gleb: I am not crazy
	#we get an error otherwise because the spawn changes before it's actually 'ready'
	#if you have questions take it up with my world management system

	world_data = WorldData.new()
	world_data.active_scene = load("res://screens/world/scenes/hub/hub.tscn")
	world_data.spawn_point = hub_spawn

func _process(delta: float) -> void:
	$Mesh.rotate_y(rotation_speed*delta)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	rotation_speed = 5
	$AnimationPlayer.play("collect")

	_end_level()
		
	await $AnimationPlayer.animation_finished

func _end_level():
	level_data.is_completed = true
	SignalBus.emit_signal("request_next")

func _on_level_exit():
	SignalBus.emit_signal("exit_level")
	
