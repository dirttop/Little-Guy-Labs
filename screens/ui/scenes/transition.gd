extends ColorRect

func _ready() -> void:
	SignalBus.connect("request_next", Callable(self, "_request_next"))
	SignalBus.connect("loaded", Callable(self, "_loaded"))
	
func _request_next():
	$AnimationPlayer.play("trans_in")
	await $AnimationPlayer.animation_finished
	SignalBus.emit_signal("load_next")

func _loaded():
	$AnimationPlayer.play("trans_out")
	await $AnimationPlayer.animation_finished
	SignalBus.emit_signal("next_ready")
