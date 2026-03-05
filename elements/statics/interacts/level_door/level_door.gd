extends StaticBody3D

@export_group("Door Settings")
@export var level_scene: PackedScene
@export var level_data: LevelData

var inside: bool = false

func _ready():
	$Popup.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		pass
		
func _on_area_body_entered(body: Node3D) -> void:
	inside = true
	$AnimationPlayer.play("pop_in")

func _on_area_body_exited(body: Node3D) -> void:
	inside = false
	$AnimationPlayer.play("pop_out")
