class_name LevelData extends Resource

@export var level_id: String = ""
@export var is_unlocked: bool = false
@export var is_completed: bool = false

@export var artifacts: Array[bool] = [false, false, false]
@export var artifact_count: int = 0
@export var challenge: bool = false
