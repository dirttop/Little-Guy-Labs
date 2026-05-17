extends Node

signal recording_started
signal recording_ended

var recording := false

const IN_LOOP_COLLISION_LAYER: int = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_record"):
		recording = not recording
		if recording:
			recording_started.emit()
		else:
			recording_ended.emit()
