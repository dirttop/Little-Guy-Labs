extends Node3D

@export var world_data: WorldData
@onready var current_scene: PackedScene = world_data.current_scene
var instanced_scene: Node3D = null

func _ready():
	instanced_scene = current_scene.instantiate()
	add_child(instanced_scene)

func _physics_process(delta: float) -> void:
	pass
	
func _on_load():
	if instanced_scene:
		instanced_scene.queue_free()
		await instanced_scene.tree_exited 
		
	current_scene = world_data.current_scene
	instanced_scene = current_scene.instantiate()
	add_child(instanced_scene)
