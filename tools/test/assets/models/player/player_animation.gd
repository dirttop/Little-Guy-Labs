extends Node3D
class_name PlayerAnimationComponent

@export var animation_tree: AnimationTree
@export var body: CharacterBody3D

func handle_animation(velocity: Vector3, is_on_floor: bool) -> void:
	var is_moving = Vector2(velocity.x, velocity.z).length() > 0.1
	var is_falling = not is_on_floor and velocity.y <= 0
	var is_jumping = not is_on_floor and velocity.y > 0 
	
	animation_tree.set("parameters/conditions/is_moving", is_moving and is_on_floor)
	animation_tree.set("parameters/conditions/is_idle", not is_moving and is_on_floor)
	animation_tree.set("parameters/conditions/is_falling", is_falling)
	animation_tree.set("parameters/conditions/is_runjump", is_jumping and is_moving)
	animation_tree.set("parameters/conditions/is_standjump", is_jumping and not is_moving)
