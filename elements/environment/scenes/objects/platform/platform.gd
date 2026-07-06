class_name MovingPlatform
extends AnimatableBody3D

## A reusable moving platform driven by one or more activators (buttons, levers,
## ...). Any node listed in [member activators] that emits `pressed` / `released`
## signals will move the platform between its starting position and
## `start + travel`. With several activators you choose whether ANY of them
## (default) or ALL of them ([member require_all]) must be active.
##
## Movement is collision-aware. Two independent flags decide how it reacts to
## things in its path:
## - [member pass_through_walls]: ignore static (World) geometry, or stop at it.
## - [member stop_for_objects]: when it pushes a movable body (a box, the
##   player) that gets pinned and can no longer move, stop rather than crushing
##   it through the level. This is what keeps pushed boxes from clipping into
##   walls / the floor.

signal arrived(at_end: bool)

## Offset from the platform's starting position to its "active" position.
@export var travel := Vector3(0, 3, 0)
## Movement speed in units / second.
@export var speed := 2.0
## When true, every activator must be active before the platform moves.
## When false, a single active activator is enough.
@export var require_all := false
## Flip the resting state: the platform starts at the "active" position and
## retracts toward start when activated.
@export var inverted := false

@export_group("Collision")
## When true the platform slides through static (World) geometry. When false it
## stops as soon as it would overlap a wall.
@export var pass_through_walls := false
## When true the platform stops once a body it is pushing can no longer move
## (e.g. a box jammed against a wall), so pushed objects never clip through
## level geometry. When false the platform ignores movable bodies and drives
## straight through them.
@export var stop_for_objects := true

## Buttons / levers that drive this platform. Each must emit `pressed` /
## `released` signals (a [PressButton] does).
@export var activators: Array[NodePath] = []

# Surfaces angled more steeply than this relative to our motion are treated as
# "in front of" us (real blockers) rather than grazing contacts such as a rider
# standing on top of the platform.
const _FRONTAL_DOT := -0.1
# How many movable bodies a single push can propagate through (platform -> box
# -> box -> ...).
const MAX_PUSH_CHAIN := 8

var _start := Vector3.ZERO
var _end := Vector3.ZERO
var _active_count := 0
var _activator_count := 0
var _settled := false


func _ready() -> void:
	_start = global_position
	_end = global_position + travel
	for path in activators:
		var node := get_node_or_null(path)
		if node == null:
			push_warning("MovingPlatform: activator not found at '%s'" % path)
			continue
		_activator_count += 1
		if node.has_signal("pressed"):
			node.connect("pressed", _on_activator_pressed)
		if node.has_signal("released"):
			node.connect("released", _on_activator_released)
	# Snap to the correct resting position so it does not slide on spawn.
	global_position = _target()
	_settled = true


func _physics_process(delta: float) -> void:
	var to_target := _target() - global_position
	if to_target.length() < 0.001:
		if not _settled:
			_settled = true
			arrived.emit(_going_to_end())
		return
	_settled = false
	_step(to_target.limit_length(speed * delta))


## Move by [param motion], reacting to whatever is in the way according to the
## collision flags.
func _step(motion: Vector3) -> void:
	var collision := move_and_collide(motion, true)
	if collision == null:
		global_position += motion
		return

	# Ignore grazing contacts (e.g. a body resting on top); only react to
	# surfaces we are actually driving into.
	if collision.get_normal().dot(motion.normalized()) > _FRONTAL_DOT:
		global_position += motion
		return

	var collider := collision.get_collider()
	var to_contact := motion - collision.get_remainder()

	if _is_pushable(collider):
		if not stop_for_objects:
			global_position += motion  # plow straight through it
			return
		# Push the body by our remaining motion and advance only as far as it
		# actually progressed along our direction, so we never overlap (and
		# never crush) it — and never drift off our own path.
		var dir := motion.normalized()
		var pushed := _push(collider, collision.get_remainder())
		global_position += to_contact + dir * maxf(pushed.dot(dir), 0.0)
	elif pass_through_walls:
		global_position += motion  # ignore the wall
	else:
		global_position += to_contact  # stop against the wall


func is_active() -> bool:
	if require_all:
		return _activator_count > 0 and _active_count >= _activator_count
	return _active_count > 0


func _going_to_end() -> bool:
	return is_active() != inverted


func _target() -> Vector3:
	return _end if _going_to_end() else _start


func _is_pushable(node: Object) -> bool:
	return node is CharacterBody3D or node is RigidBody3D


## Move [param body] by [param motion], chain-pushing other movable bodies in
## its way (a row of boxes, the player) and letting it slide along grazing
## surfaces (the floor under a pushed box, a ramp) — but never through static
## blockers. Returns how far it actually travelled. [param chain] carries the
## bodies already being pushed this step, to cap the chain and avoid cycles.
func _push(body: PhysicsBody3D, motion: Vector3, chain: Array = []) -> Vector3:
	var before := body.global_position
	var dir := motion.normalized()
	var remaining := motion
	chain.append(body)
	# Boxes don't collide with the player on their own (and vice versa), but a
	# platform-driven push must see every movable body so it can pass the push
	# along instead of clipping through. Restored below.
	var original_mask: int = body.collision_mask
	body.collision_mask |= 6  # Player + Rigids
	for _i in 4:
		var collision := body.move_and_collide(remaining)
		if collision == null:
			break
		var collider := collision.get_collider()
		remaining = collision.get_remainder()
		if _is_pushable(collider) and not chain.has(collider) and chain.size() < MAX_PUSH_CHAIN:
			# Pass the push down the chain, then follow the blocker by however
			# far it actually progressed along our direction.
			var pushed := _push(collider, remaining, chain)
			var progress := maxf(pushed.dot(dir), 0.0)
			if progress < 0.001:
				break
			remaining = dir * progress
		else:
			remaining = remaining.slide(collision.get_normal())
			# Only keep sliding while it still makes progress in the push
			# direction; otherwise the body is genuinely jammed.
			if remaining.dot(dir) < 0.001:
				break
	body.collision_mask = original_mask
	return body.global_position - before


func _on_activator_pressed() -> void:
	_active_count += 1


func _on_activator_released() -> void:
	_active_count = max(_active_count - 1, 0)
