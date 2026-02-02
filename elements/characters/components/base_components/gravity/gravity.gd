extends Component
class_name GravityComponent

@export_subgroup("Settings")
@export var base: float = 8.0

var is_falling: bool = false
var disabled: bool = false
var mod: float = 0.0

func handle_gravity(body: CharacterBody2D, delta: float) -> void:
	if not body.is_on_floor() and !disabled:
		var gravity = base + mod
		body.velocity.y -= gravity * delta 
		
	is_falling = body.velocity.y < 0 and not body.is_on_floor()

func disable_gravity():
	disabled = true

func enable_gravity():
	disabled = false
	
func set_mod(value: float):
	mod = value

func reset_mod():
	mod = 0
