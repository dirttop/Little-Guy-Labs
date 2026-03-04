extends Control

@export var slot_num: int = 1
var world_data: WorldData = load("res://globals/data/world_data/world_data.tres")

@onready var new_ui = $SlotMargin/New
@onready var load_ui = $SlotMargin/Load

@onready var playtime = $SlotMargin/Load/Playtime
@onready var section = $SlotMargin/Load/Section
@onready var artifacts = $SlotMargin/Load/Artifacts/Count
@onready var upgrades = $SlotMargin/Load/Upgrades

func _ready() -> void:
	$SlotMargin/SlotLabel.text = "Slot " + str(slot_num)
	update_slot(slot_num)

func update_slot(slot_id: int) -> void:
	var data = SaveManager.get_data(slot_id)
	
	if data.is_empty():
		new_ui.visible = true
		load_ui.visible = false
	else:
		new_ui.visible = false
		load_ui.visible = true
		
		var total_playtime = data.playtime
		var playtime_sec = total_playtime % 60
		var playtime_min = (total_playtime / 60) % 60
		var playtime_hour = total_playtime / 3600
		
		playtime.text = "%02d:%02d:%02d" % [playtime_hour, playtime_min, playtime_sec]
		
		section.text = data.section
		artifacts.text = str(data.artifact_count)

func _on_slot_button_pressed() -> void:
	SaveManager.load_save(slot_num)
