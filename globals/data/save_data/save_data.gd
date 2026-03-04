class_name SaveData extends Resource

@export_group("Game Data")
@export var playtime: float = 0.0
@export var levels: Dictionary[String, LevelData] = {}
@export var artifact_count: int = 0
@export var upgrades: Array[UpgradeData] = []
@export var section: String = ""

@export_group("Session Data")
@export var last_scene: PackedScene
@export var last_spawn: String = ""
