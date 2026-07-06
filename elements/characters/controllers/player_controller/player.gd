extends CharacterBody3D
class_name Player

@export var speed: int
@export var acceleration: int
@export var pushing_force: float

@export var mass: float = 80
@export var rotation_speed: float = 10.0

# Used for recording loops
var input_vector: Vector3

var picked_up_object = null

func _ready() -> void:
	TimeLoopManager.recording_ended.connect(_on_playback_while_pickup)

func _physics_process(delta: float) -> void:
	_handle_horizontal_velocity(delta)
	_handle_pickup()
	
	$Gravity.handle_gravity(self, delta)
	$PlayerJump.handle_jump()
	$PlayerMesh.handle_animation(velocity, is_on_floor())
	
	if $PlayerJump.holding_jump:
		input_vector.y = $PlayerJump.jump_velocity
	else:
		input_vector.y = 0
	#print(velocity)
	#_handle_collisions(_prev_velocity)
	#if not is_pushing:
		#_prev_velocity = velocity
	
	if not picked_up_object:
		# PlayerPickup calls this when picking up
		move_and_slide()


func _handle_horizontal_velocity(delta: float) -> void:
	var v = Input.get_vector("left", "right", "forwards", "backwards")
	var move_vector = Vector3(v.x, 0, v.y)
	var camera = get_viewport().get_camera_3d()
	if (camera == null):
		printerr("Error Missing Camera: No Camera3D enabled")
	else:
		var marker = camera.get_parent().get_parent()
		#if marker is not Marker3D:
		#	pass #hey rafe, commented this out bc im fucking with my own camera implement
			#printerr("Error Invalid Camera: Camera3D must be the child of a Marker3D node to determine rotation.")
		move_vector = move_vector.rotated(Vector3.UP, marker.rotation.y)
	
	if v.length_squared() > 0.0:
		var target_angle = atan2(move_vector.x, move_vector.z)
		$PlayerMesh.rotation.y = lerp_angle($PlayerMesh.rotation.y, target_angle, rotation_speed * delta)
	#handles mesh rotation
	
	var target_vel = move_vector * speed
	var next_velocity = velocity.move_toward(target_vel, acceleration * delta)
	
	if target_vel != Vector3.ZERO and not picked_up_object:
		var rot_target = Vector3(target_vel.x, 0, target_vel.z)
		var rot_angle = Vector3(0, 0, 1).signed_angle_to(rot_target, Vector3.UP)
		rotation.y = rot_angle
		
	velocity.x = next_velocity.x
	velocity.z = next_velocity.z
	input_vector.x = velocity.x
	input_vector.z = velocity.z


func _handle_pickup() -> void:
	if not picked_up_object:
		if Input.is_action_just_pressed("interact") and $PickupRaycast.is_colliding():
			var c = $PickupRaycast.get_collider()
			for child in c.get_children():
				if child is PlayerPickup:
					child.pickup(self)
					picked_up_object = c
					break
	else:
		if Input.is_action_just_pressed("interact"):
			for child in picked_up_object.get_children():
				if child is PlayerPickup:
					child.drop(false)
					picked_up_object = null
					break


func _on_playback_while_pickup() -> void:
	if not picked_up_object:
		return
	for child in picked_up_object.get_children():
		if child is PlayerPickup:
			child.drop(true)
			picked_up_object = null
			break
