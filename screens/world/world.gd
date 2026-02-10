extends Node3D

@export var world_data: WorldData
@export var player_scene: PackedScene

var instanced_scene: Node3D = null
var instanced_player: CharacterBody3D = null
var player_spawn: Vector3

var is_loading: bool = false
var loading_path: String = ""
var load_progress: Array = []

func _ready():
	SignalBus.connect("load_next", Callable(self, "_load_next"))
	if not is_loading:
		_load_next()

func _physics_process(delta: float) -> void:
	_load_progress()
	
func _load_next():
	_start_load()

func _start_load():
	if world_data.active_scene:
		loading_path = world_data.active_scene.resource_path
		var load_scene = ResourceLoader.load_threaded_request(loading_path)
		if load_scene == OK:
			is_loading = true
			load_progress = []
		else:
			printerr("Error (File): Failed to start threaded load with scene {loading_path}.")
	else:
		printerr("Error (File): No active scene is set.")

func _load_progress():
	var status = ResourceLoader.load_threaded_get_status(loading_path, load_progress)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		is_loading = false
		var loaded_scene = ResourceLoader.load_threaded_get(loading_path)
		_instance_scene(loaded_scene)
		_set_player_spawn()
		_spawn_player()
		SignalBus.emit_signal("loaded")
		return
		
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		is_loading = false
		printerr("Error (File): Threaded load failed.")
		return
	return
	
func _instance_scene(target_scene: PackedScene):
	if instanced_scene:
		instanced_scene.queue_free()
		await instanced_scene.tree_exited 
		
	instanced_scene = target_scene.instantiate()
	add_child(instanced_scene)
	return

func _set_player_spawn():
	if world_data.spawn_point != "":
		var spawn_point = instanced_scene.find_child(world_data.spawn_point, true, false)
		if spawn_point:
			player_spawn = spawn_point.global_position
			return
		else:
			printerr("Error (World): No spawn point '{world_data.spawn_point}' found in scene.")
			return

func _spawn_player():
	if instanced_player:
		instanced_player.queue_free()
		await instanced_scene.tree_exited
	
	instanced_player = player_scene.instantiate()
	instanced_player.position = player_spawn
	instanced_scene.add_child(instanced_player)
	return
