extends Node3D

@onready var camera_arm: SpringArm3D = $CameraArm

@export_group("Camera Settings")
@export var follow_mode: bool = false
@export_range(0.1, 10.0, 0.1) var mouse_sens: float = 2.0
@export_range(0.1, 10.0, 0.1) var controller_sens: float = 1.0

@export_group("Zoom Settings")
@export var zoom_speed: float = 2.0
@export var min_zoom: float = 4.0
@export var max_zoom: float = 10.0
@export var zoom_smooth: float = 5.0

@export_group("Rotation Settings") 
@export var pitch_up: float = -80.0 #degrees
@export var pitch_down: float = 80.0 #degrees

const sens_mult: float = 0.001 

var is_rotating: bool = false
var target_zoom: float = 10.0

func _ready() -> void:
	target_zoom = camera_arm.spring_length
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)
	rotation.x = clamp(rotation.x, deg_to_rad(pitch_up), deg_to_rad(pitch_down))

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input(event)
	
	if event.is_action_pressed("camera_zoom_in"):
		target_zoom -= zoom_speed
	elif event.is_action_pressed("camera_zoom_out"):
		target_zoom += zoom_speed
		
	target_zoom = clamp(target_zoom, min_zoom, max_zoom)

func _mouse_input(event: InputEvent):
	if event.is_action_pressed("camera_rotate"):
		is_rotating = true
	elif event.is_action_released("camera_rotate"):
		is_rotating = false

	if is_rotating and event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sens * sens_mult
		rotation.x -= event.relative.y * mouse_sens * sens_mult
		rotation.x = clamp(rotation.x, deg_to_rad(pitch_up), deg_to_rad(pitch_down))

func _controller_input(delta: float):
	var input_vector = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if input_vector.length() > 0:
		var x_rot = input_vector.x * controller_sens * 2.0 * delta
		var y_rot = input_vector.y * controller_sens * 2.0 * delta
		_rotate_camera(x_rot, y_rot)

func _rotate_camera(x_delta: float, y_delta: float) -> void:
	rotation.y -= x_delta
	rotation.x -= y_delta
	rotation.x = clamp(rotation.x, deg_to_rad(pitch_up), deg_to_rad(pitch_down))

func _process(delta: float) -> void:
	_controller_input(delta)
	
	camera_arm.spring_length = lerp(camera_arm.spring_length, target_zoom, zoom_smooth * delta)
	
	if follow_mode:
		global_position = get_tree().get_first_node_in_group("player").global_position
