extends Node
class_name LoopHandler

@export var target: CharacterBody3D

var start_transform: Transform3D
var impulse_framelist: Array[Vector3]
var framelist_index: int = 0
var recording := false
var playing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeLoopManager.recording_started.connect(_start_recording)
	TimeLoopManager.recording_ended.connect(_playback)


func _physics_process(_delta: float) -> void:
	if recording:
		_record_frame()
	if playing:
		if framelist_index == 0:
			target.sleeping = false
		print(impulse_framelist.size())
		#target.apply_central_impulse(impulse_framelist[framelist_index])
		framelist_index += 1
		if framelist_index >= impulse_framelist.size():
			target.transform = start_transform
			framelist_index = 0
			target.sleeping = true


func _start_recording() -> void:
	recording = true
	playing = false
	impulse_framelist = []
	start_transform = target.transform


func _record_frame() -> void:
	var state = PhysicsServer3D.body_get_direct_state(target)
	var frame_impulse := Vector3.ZERO
	for i in state.get_contact_count():
		frame_impulse += state.get_contact_impulse(i)
	frame_impulse = Vector3(-frame_impulse.x, frame_impulse.y, -frame_impulse.z)
	impulse_framelist.append(frame_impulse)

func _playback() -> void:
	playing = true
	recording = false
	framelist_index = 0
	target.collision_layer += TimeLoopManager.IN_LOOP_COLLISION_LAYER
	target.transform = start_transform
