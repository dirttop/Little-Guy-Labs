extends TextureRect

@onready var animation = $AnimationPlayer

@export_group("Icon Settings")
@export var uncollected: Texture2D
@export var collected: Texture2D
@export var in_level: bool = true

@export_group("Icon Data")
@export var artifact_index: int = 0

var _level_data: LevelData

func _ready() -> void:
	SignalBus.connect("enter_level", Callable(self, "_on_enter_level"))
	SignalBus.connect("artifact_collected", Callable(self, "_on_artifact_collected"))

func _on_enter_level(level_data):
	_level_data = level_data
	_update_state()

func _on_artifact_collected(index):
	if artifact_index == index:
		animation.play("collect")
		await animation.animation_finished
		_update_state()

func _update_state():
	if _level_data.artifacts[artifact_index]:
		texture = collected
	else:
		texture = uncollected

	
	
	
