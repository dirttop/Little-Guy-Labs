extends CharacterBody3D

@export var speed: int
@export var acceleration: int
@export var pushing_force: int

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_handle_horizontal_velocity(delta)
	_handle_collisions()
	$Gravity.handle_gravity(self, delta)
	$PlayerJump.handle_jump()
	
	move_and_slide()


func _handle_horizontal_velocity(delta: float) -> void:
	var v = Input.get_vector("left", "right", "forwards", "backwards")
	var move_vector = Vector3(v.x, 0, v.y)
	var camera = get_viewport().get_camera_3d()
	if (camera == null):
		printerr("Error Missing Camera: No Camera3D enabled")
	else:
		var marker = camera.get_parent()
		if marker is not Marker3D:
			printerr("Error Invalid Camera: Camera3D must be the child of a Marker3D node to determine rotation.")
		move_vector = move_vector.rotated(Vector3.UP, marker.rotation.y)
	var target_vel = move_vector * speed
	var next_velocity = velocity.move_toward(target_vel, acceleration * delta)
	velocity.x = next_velocity.x
	velocity.z = next_velocity.z


func _handle_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			var push_vec = -collision.get_normal()
			if abs(push_vec.x) > abs(push_vec.z):
				push_vec = Vector3(push_vec.x, 0, 0)
			else:
				push_vec = Vector3(0, 0, push_vec.z)
			print(push_vec * pushing_force)
			collider.apply_central_impulse(push_vec * pushing_force)
