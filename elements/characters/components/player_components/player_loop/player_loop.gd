extends Node
class_name PlayerLoop

@export var player: Player

var ghost_scene = preload("res://elements/characters/controllers/npc_controller/player_ghost/player_ghost.tscn")

var recording := false

var start_transform: Transform3D
var input_framelist: Array[Vector3]

func _ready() -> void:
	TimeLoopManager.recording_started.connect(_start_recording)
	TimeLoopManager.recording_ended.connect(_playback.bind(true))

func _physics_process(_delta: float) -> void:
	if recording:
		input_framelist.append(player.input_vector)

func _start_recording() -> void:
	input_framelist = []
	recording = true
	start_transform = player.transform

func _playback(has_ghost: bool) -> void:
	recording = false
	var ghost: PlayerGhost = ghost_scene.instantiate()
	ghost.mass = player.mass
	ghost.visible = has_ghost
	ghost.transform = start_transform
	ghost.input_framelist = input_framelist
	player.get_parent().call_deferred("add_child", ghost)
