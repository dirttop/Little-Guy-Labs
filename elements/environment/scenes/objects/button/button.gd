class_name PressButton
extends StaticBody3D

signal pressed
signal released

## How far the cap moves while pressed (local space).
@export var press_offset := Vector3(0, -0.06, 0)
## How fast the cap animates toward its target, in units / second.
@export var press_speed := 8.0

@onready var _cap: Node3D = $Cap

var _cap_rest := Vector3.ZERO
var _bodies := 0


func _ready() -> void:
	_cap_rest = _cap.position


func _process(delta: float) -> void:
	var target := _cap_rest + press_offset if is_pressed() else _cap_rest
	_cap.position = _cap.position.move_toward(target, press_speed * delta)


func is_pressed() -> bool:
	return _bodies > 0


func _on_press_zone_body_entered(_body: Node3D) -> void:
	_bodies += 1
	if _bodies == 1:
		pressed.emit()


func _on_press_zone_body_exited(_body: Node3D) -> void:
	_bodies = max(_bodies - 1, 0)
	if _bodies == 0:
		released.emit()
