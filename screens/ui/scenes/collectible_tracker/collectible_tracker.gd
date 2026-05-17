extends Control

func _ready() -> void:
	visible = false
	SignalBus.connect("enter_level", Callable(self, "_on_enter_level"))
	SignalBus.connect("exit_level", Callable(self, "_on_exit_level"))
	
func _on_enter_level(_level_data):
	visible = true
	
func _on_exit_level():
	visible = false
