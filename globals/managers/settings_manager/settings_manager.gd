extends Node

const settings_path: String = "user://settings.cfg"
var config := ConfigFile.new()

func save_settings() -> void:
	if config:
		config.save(settings_path)
		
func load_settings() -> void:
	if config.load(settings_path) == OK:
		pass
		
