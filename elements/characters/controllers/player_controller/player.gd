extends CharacterBody3D
class_name Player

@export var speed: int
@export var acceleration: int
@export var pushing_force: float

@export var mass: float = 80

# Used for recording loops
var input_vector: Vector3

var picking_up := false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	_handle_horizontal_velocity(delta)
	_handle_pickup()
	
	$Gravity.handle_gravity(self, delta)
	#print(velocity.y)
	$PlayerJump.handle_jump()
	
	if $PlayerJump.holding_jump:
		input_vector.y = $PlayerJump.jump_velocity
	else:
		input_vector.y = 0
	#print(velocity)
	#_handle_collisions(_prev_velocity)
	#if not is_pushing:
		#_prev_velocity = velocity
	
	if not picking_up:
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
	var target_vel = move_vector * speed
	var next_velocity = velocity.move_toward(target_vel, acceleration * delta)
	
	if target_vel != Vector3.ZERO and not picking_up:
		var rot_target = Vector3(target_vel.x, 0, target_vel.z)
		var rot_angle = Vector3(0, 0, 1).signed_angle_to(rot_target, Vector3.UP)
		rotation.y = rot_angle
		
	velocity.x = next_velocity.x
	velocity.z = next_velocity.z
	input_vector.x = velocity.x
	input_vector.z = velocity.z


func _handle_pickup() -> void:
	if not picking_up:
		if Input.is_action_just_pressed("interact") and $PickupRaycast.is_colliding():
			var c = $PickupRaycast.get_collider()
			for child in c.get_children():
				if child is PlayerPickup:
					child.pickup(self)
					picking_up = true
					# TODO: pickup mechanics
					break

#func _handle_collisions(prev_velocity: Vector3) -> void:
	#var found_pushable = false
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
		#
		#if collider is CharacterBody3D:
			#found_pushable = true
			#is_pushing = true
			#print("prev: " + str(prev_velocity))
			#for node in collider.get_children():
				#if node is PhysicsMove:
					#if prev_velocity != Vector3.ZERO:
						#collider.velocity = prev_velocity
	#if not found_pushable:
		#is_pushing = false
