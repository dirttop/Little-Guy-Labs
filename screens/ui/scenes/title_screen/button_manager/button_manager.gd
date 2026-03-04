extends Node
@onready var animation: AnimationPlayer = $"../AnimationPlayer"

func _on_start_pressed() -> void:
	animation.play("hide_main")
	await animation.animation_finished
	animation.play("show_saves")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_achievements_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	animation.play("hide_saves")
	await animation.animation_finished
	animation.play("show_main")
