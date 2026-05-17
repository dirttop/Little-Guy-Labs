extends CharacterBody3D
class_name Player

@export var speed: int
@export var acceleration: int
@export var pushing_force: float

@export var mass: float = 80

# Used for recording loops
var input_vector: Vector3

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_handle_horizontal_velocity(delta)
	_handle_collisions()
	$Gravity.handle_gravity(self, delta)
	#print(velocity.y)
	$PlayerJump.handle_jump()
	
	if $PlayerJump.holding_jump:
		input_vector.y = $PlayerJump.jump_velocity
	else:
		input_vector.y = 0
	
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
	var target_vel = move_vector * speed
	var next_velocity = velocity.move_toward(target_vel, acceleration * delta)
	velocity.x = next_velocity.x
	velocity.z = next_velocity.z
	input_vector.x = velocity.x
	input_vector.z = velocity.z


func _handle_collisions() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			var push_dir = -collision.get_normal()
			# How much velocity the object needs to increase to match player velocity in the push direction
			var velocity_diff_in_push_dir = self.velocity.dot(push_dir) - collider.linear_velocity.dot(push_dir)
			# Only count velocity towards push dir, away from character
			velocity_diff_in_push_dir = max(0., velocity_diff_in_push_dir)
			# Objects with more mass than us should be harder to push. But doesn't really make sense to push faster than we are going
			var mass_ratio = min(1., mass / collider.mass)
			# Optional add: Don't push object at all if it's 4x heavier or more
			if mass_ratio < 0.25:
				continue
			# Don't push object from above/below
			push_dir.y = 0
			# 5.0 is a magic number, adjust to your needs
			var push_force = mass_ratio * 5.0
			collider.apply_impulse(push_dir * velocity_diff_in_push_dir * push_force, collision.get_position() - collider.global_position)
