extends Node
@onready var animation: AnimationPlayer = $"../AnimationPlayer"
@onready var main_menu: Control = $Margin/Main
@onready var saves_menu: Control = $Margin/Saves

func _ready() -> void:
	saves_menu.visible = false
	main_menu.visible = true

func _on_start_pressed() -> void:
	animation.play("hide_main")
	await animation.animation_finished
	main_menu.visible = false
	saves_menu.visible = true
	animation.play("show_saves")

func _on_options_pressed() -> void:
	pass

func _on_achievements_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	animation.play("hide_saves")
	await animation.animation_finished
	saves_menu.visible = false
	main_menu.visible = true
	animation.play("show_main")
