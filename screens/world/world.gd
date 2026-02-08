extends Node3D

@export var world_data: WorldData
@onready var current_scene: PackedScene = world_data.active_scene
@export var player_scene: PackedScene
var instanced_scene: Node3D = null
var instanced_player: CharacterBody3D = null
var player_spawn: Vector3

func _ready():
	SignalBus.connect("load_next", Callable(self, "_load_next"))
	_load_next()

func _physics_process(delta: float) -> void:
	pass
	
func _load_next():
	_instance_scene()
	_set_player_spawn()
	_spawn_player()
	await instanced_player.tree_entered
	SignalBus.emit_signal("loaded")
	
func _instance_scene():
	if instanced_scene:
		instanced_scene.queue_free()
		await instanced_scene.tree_exited 
		
	current_scene = world_data.current_scene
	instanced_scene = current_scene.instantiate()
	add_child(instanced_scene)

func _set_player_spawn():
	if world_data.spawn_point != "":
		var spawn_point = instanced_scene.find_child(world_data.spawn_point, true, false)
		if spawn_point:
			player_spawn = spawn_point.global_position
			return player_spawn
		else:
			printerr("Error (World): No spawn point '{world_data.spawn_point}' found in scene.")
			return null

func _spawn_player():
	if instanced_player:
		instanced_player.queue_free()
		await instanced_scene.tree_exited
		
	instanced_player = player_scene.instantiate()
	instanced_scene.add_child(instanced_player)
