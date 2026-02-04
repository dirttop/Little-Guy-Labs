extends Node

@export var player: CharacterBody3D
@export var jump_velocity: int

var jumped := false
var coyote_window := true
var holding_jump := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player == null:
		printerr("Error Missing Player: Player node of PlayerJump is null.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_jump() -> void:
	if player.is_on_floor():
		jumped = false
		coyote_window = true
		holding_jump = false
		if not $JumpBufferTimer.is_stopped():
			jump()
			$JumpBufferTimer.stop()
	else:
		if coyote_window and $CoyoteTimer.is_stopped():
			$CoyoteTimer.start(.1)
	
	# Jump cut
	if holding_jump:
		if Input.is_action_pressed("jump"):
			player.velocity.y = jump_velocity
		else:
			holding_jump = false
	
	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		jump()
	
	elif not player.is_on_floor() and Input.is_action_just_pressed("jump"):
		if jumped: return
		
		# Recently left the ground
		if not $CoyoteTimer.is_stopped():
			jump()
		
		elif $JumpBufferTimer.is_stopped():
			$JumpBufferTimer.start(.1)


func jump() -> void:
	$JumpCutTimer.start(.2)
	player.velocity.y = jump_velocity
	jumped = true
	holding_jump = true


func _on_coyote_timer_timeout() -> void:
	coyote_window = false


func _on_jump_cut_timer_timeout() -> void:
	holding_jump = false
