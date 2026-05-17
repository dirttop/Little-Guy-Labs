extends Node
class_name PhysicsMove

@export var target: CharacterBody3D
@export var mass: float
@export var friction: float
@export var air_resistance: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target.is_on_floor():
		target.velocity = target.velocity.move_toward(Vector3.ZERO, friction * delta)
	else:
		target.velocity = target.velocity.move_toward(Vector3.ZERO, air_resistance * delta)
		target.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta


func apply_impulse(force: Vector3, delta: float) -> void:
	var impulse = force * delta
	var vel_change = impulse / mass
	target.velocity += vel_change
