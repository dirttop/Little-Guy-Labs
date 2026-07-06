class_name ToggleButton
extends StaticBody3D

## A reusable on/off button. Each time a body (the player, a box, ...) steps on
## it, it flips state: off -> on emits [signal pressed], on -> off emits
## [signal released], so it drops straight into a [MovingPlatform]'s activators
## just like a [PressButton]. While "on" the cap rests partway down so it stays
## visually obvious you can step on it again to switch it back.

signal pressed
signal released

## Cap position while the button is toggled on. Kept shallow (a partial press)
## so the button still reads as "steppable" in its on state.
@export var on_offset := Vector3(0, -0.03, 0)
## How fast the cap animates toward its target, in units / second.
@export var press_speed := 8.0

@onready var _cap: Node3D = $Cap

var _cap_rest := Vector3.ZERO
var _on := false
var _bodies := 0


func _ready() -> void:
	_cap_rest = _cap.position


func _process(delta: float) -> void:
	var target := _cap_rest + on_offset if _on else _cap_rest
	_cap.position = _cap.position.move_toward(target, press_speed * delta)


func is_on() -> bool:
	return _on


func _on_press_zone_body_entered(_body: Node3D) -> void:
	_bodies += 1
	# Only the first body of a fresh step flips the switch.
	if _bodies == 1:
		_toggle()


func _on_press_zone_body_exited(_body: Node3D) -> void:
	_bodies = max(_bodies - 1, 0)


func _toggle() -> void:
	_on = not _on
	if _on:
		pressed.emit()
	else:
		released.emit()
