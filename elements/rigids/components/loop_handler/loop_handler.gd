extends Node
class_name LoopHandler

@export var target: CharacterBody3D
@export_flags("Velocity", "Rotation") var record_properties = 3

var start_transform: Transform3D
var framelist: Array[LoopFramelistData]
var framelist_index: int = 0
var recording := false
var playing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeLoopManager.recording_started.connect(_start_recording)
	TimeLoopManager.recording_ended.connect(_start_playback)


func _physics_process(_delta: float) -> void:
	if recording:
		_record_frame()
	if playing:
		_play_frame()


func _start_recording() -> void:
	recording = true
	playing = false
	framelist = []
	start_transform = target.transform


func _record_frame() -> void:
	var curr_data = LoopFramelistData.new()
	if record_properties % 4 == 1 or record_properties % 4 == 3:
		curr_data.velocity = target.velocity
	if record_properties % 4 == 2 or record_properties % 4 == 3:
		curr_data.rotation = target.rotation
	framelist.append(curr_data)

func _start_playback() -> void:
	playing = true
	recording = false
	framelist_index = 0
	target.collision_layer += TimeLoopManager.IN_LOOP_COLLISION_LAYER
	target.transform = start_transform

func _play_frame() -> void:
	var curr_data = framelist[framelist_index]
	print(curr_data.velocity)
	if record_properties % 4 == 1 or record_properties % 4 == 3:
		target.velocity = curr_data.velocity
	if record_properties % 4 == 2 or record_properties % 4 == 3:
		target.rotation = curr_data.rotation
	
	framelist_index += 1
	if framelist_index >= framelist.size():
		target.transform = start_transform
		framelist_index = 0
