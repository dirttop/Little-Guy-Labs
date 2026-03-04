extends Control

@onready var animation = $AnimationPlayer

func _ready() -> void:
	animation.play("show_main")
