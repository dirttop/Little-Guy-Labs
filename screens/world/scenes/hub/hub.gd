extends Node3D

func _ready() -> void:
	SignalBus.connect("next_ready", Callable(self, "_on_hub_load"))

func _on_hub_load():
	SaveManager.save_game(SaveManager.current_slot)
