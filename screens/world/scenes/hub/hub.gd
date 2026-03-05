extends Node3D

func _ready() -> void:
	SignalBus.connect("next_ready", Callable(self, "_on_hub_load"))

func _on_hub_load():
	SaveManager.save_game(SaveManager.current_slot)

#Note that saving probably should be moved out of the root at some point
#This really will be populated with story management I think?
#tbh might not be, we shall see

#get ready for this scene to be massive and annoying
