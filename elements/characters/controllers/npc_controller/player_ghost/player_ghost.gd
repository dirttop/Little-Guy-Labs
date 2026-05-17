extends CharacterBody3D
class_name PlayerGhost

var mass

var input_framelist: Array[Vector3]
var index = 0
var start_transform: Transform3D

func _ready() -> void:
	start_transform = transform
	if not visible:
		collision_mask = TimeLoopManager.IN_LOOP_COLLISION_LAYER

func _physics_process(delta: float) -> void:
	$Gravity.handle_gravity(self, delta)
	var curr_input = input_framelist[index]
	if curr_input.y != 0:
		velocity = curr_input
	else:
		velocity.x = curr_input.x
		velocity.z = curr_input.z
	index += 1
	
	if index >= input_framelist.size():
		index = 0
		transform = start_transform
	
	_handle_collisions()
	
	move_and_slide()

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
