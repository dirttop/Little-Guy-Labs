extends Control

@onready var loader = $Screen/Margin/Loader
@onready var timer = $Screen/Margin/Loader/LoaderLoop/Timer
@onready var animation = $AnimationPlayer

func _ready() -> void:
	SignalBus.connect("request_next", Callable(self, "_request_next"))
	SignalBus.connect("loaded", Callable(self, "_loaded"))
	timer.start()
	
func _request_next():
	$Screen/In.visible = true
	$Screen/Out.visible = false
	timer.start()
	animation.play("trans_in")
	await animation.animation_finished
	_show_loader()
	await animation.animation_finished
	SignalBus.emit_signal("load_next")

func _loaded():
	$Screen/In.visible = false
	$Screen/Out.visible = true
	_hide_loader()
	await animation.animation_finished
	timer.stop()
	animation.play("trans_out")
	await animation.animation_finished
	SignalBus.emit_signal("next_ready")

func _show_loader():
	animation.play("show_loader")

func _hide_loader():
	animation.play("hide_loader")
