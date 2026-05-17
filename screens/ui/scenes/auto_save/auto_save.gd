extends Control

func _ready() -> void:
	SignalBus.connect("saving", Callable(self, "_display_autosave"))
	SignalBus.connect("saved", Callable(self, "_hide_autosave"))

func _display_autosave():
	$AnimationPlayer.play("show_icon")

func _hide_autosave():
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("hide_icon")
