@tool
extends Resource
class_name AudioEntry

@export var stream: AudioStream

@export_range(0.0, 1.0) var volume_normal = 1.0

@export_range(0.0, 1.0) var pitch_var = 0.05

func get_volume():
	if volume_normal == 0.0:
		return -80.0 #gleb: -80.0 is muted
	return linear_to_db(volume_normal)
