class_name PlayerPickup
extends Node

@export var target: CharacterBody3D
@export var physics_move: PhysicsMove
var picked_up = false

var player: Player = null

var block_pos_x = false
var block_pos_z = false
var block_neg_x = false
var block_neg_z = false

var block_target_pos_x = false
var block_target_pos_z = false
var block_target_neg_x = false
var block_target_neg_z = false

var target_dist = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target == null:
		target = get_parent()
	if physics_move == null:
		for c in target.get_children():
			if c is PhysicsMove:
				physics_move = c


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not picked_up:
		return
	
	target.velocity = player.velocity
	
	if block_neg_x and player.velocity.x < 0:
		player.velocity.x = 0
	if block_neg_z and player.velocity.z < 0:
		player.velocity.z = 0
	if block_pos_x and player.velocity.x > 0:
		player.velocity.x = 0
	if block_pos_z and player.velocity.z > 0:
		player.velocity.z = 0
	
	if block_target_neg_x and target.velocity.x < 0:
		target.velocity.x = 0
	if block_target_neg_z and target.velocity.z < 0:
		target.velocity.z = 0
	if block_target_pos_x and target.velocity.x > 0:
		target.velocity.x = 0
	if block_target_pos_z and target.velocity.z > 0:
		target.velocity.z = 0
	
	var curr_position = player.position
	player.move_and_slide()
	if player.position.x == curr_position.x:
		target.velocity.x = 0
	if player.position.z == curr_position.z:
		target.velocity.z = 0
	
	target.move_and_slide()
	
	var dist_diff = (player.position - target.position) - target_dist
	player.position -= dist_diff


func pickup(p: Player) -> void:
	physics_move.enabled = false
	picked_up = true
	player = p
	# Ignore the held box without taking it off the Rigids layer, so platforms
	# and other objects still see it.
	player.add_collision_exception_with(target)
	target_dist = player.position - target.position
	
	var sides = player.get_node("PickupSideDetection")
	if not sides.get_node("Side1").is_connected("body_entered", _on_player_side_1_body_entered):
		sides.get_node("Side1").connect("body_entered", _on_player_side_1_body_entered)
		sides.get_node("Side2").connect("body_entered", _on_player_side_2_body_entered)
		sides.get_node("Side3").connect("body_entered", _on_player_side_3_body_entered)
		sides.get_node("Side4").connect("body_entered", _on_player_side_4_body_entered)
		
		sides.get_node("Side1").connect("body_exited", _on_player_side_1_body_exited)
		sides.get_node("Side2").connect("body_exited", _on_player_side_2_body_exited)
		sides.get_node("Side3").connect("body_exited", _on_player_side_3_body_exited)
		sides.get_node("Side4").connect("body_exited", _on_player_side_4_body_exited)


func drop(is_recording: bool) -> void:
	picked_up = false
	if not is_recording:
		physics_move.enabled = true
	
	target.collision_layer += 4
	
	player = null


func _on_side_1_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_pos_z = true


func _on_side_2_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_pos_x = true


func _on_side_3_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_neg_z = true


func _on_side_4_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_neg_x = true


func _on_side_1_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_pos_z = false


func _on_side_2_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_pos_x = false


func _on_side_3_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_neg_z = false


func _on_side_4_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_neg_x = false


func _on_player_side_1_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_target_neg_x = true


func _on_player_side_2_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_target_pos_z = true


func _on_player_side_3_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_target_pos_x = true


func _on_player_side_4_body_entered(_body: Node3D) -> void:
	if picked_up:
		block_target_neg_z = true


func _on_player_side_1_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_target_neg_x = false


func _on_player_side_2_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_target_pos_z = false


func _on_player_side_3_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_target_pos_x = false


func _on_player_side_4_body_exited(_body: Node3D) -> void:
	if picked_up:
		block_target_neg_z = false
