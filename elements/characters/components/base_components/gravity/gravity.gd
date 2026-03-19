extends Component
class_name GravityComponent

@export_subgroup("Settings")
@export var modifier: float = 1.0

var is_falling: bool = false
var disabled: bool = false

func handle_gravity(body: CharacterBody3D, delta: float) -> void:
	if not body.is_on_floor() and !disabled:
		var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		gravity *= modifier
		body.velocity.y -= gravity * delta
		
	is_falling = body.velocity.y < 0 and not body.is_on_floor()
