extends Node3D

var rotate_time = .3
var step = 0
var step_count = 0

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("rotate_camera_left") and step == 0:
		step = -45 / (rotate_time * 50)
		step_count = rotate_time * 50
	elif Input.is_action_just_pressed("rotate_camera_right") and step == 0:
		step = 45 / (rotate_time * 50)
		step_count = rotate_time * 50
	
	if step_count > 0:
		$CameraPivot.rotate_y(deg_to_rad(step))
		step_count -= 1
	else:
		step = 0
