extends Node

@export var audio_library: AudioLibrary
const audio_player = preload("res://elements/audio/tools/audio_player/audio_player.tscn")

@onready var music_player = $MusicPlayer
@onready var sfx_pool = $PlayerPool.get_children()

func play_sfx(key: StringName):
	var player = get_player()
	if not player:
		return

	var entry: AudioEntry = audio_library.sfx_library.get(key)
	if not entry:
		printerr("Audio Error: SFX key not found in library: ", key)
		return

	player.stream = entry.stream
	player.volume_db = entry.get_volume()
	player.pitch_scale = 1.0 + randf_range(-entry.pitch_var, entry.pitch_var)
	player.play()

func play_sfx_at(key: StringName, position: Vector2):
	var entry: AudioEntry = audio_library.sfx_library.get(key)
	if not entry:
		printerr("Error (Audio): SFX key not found in library: ", key)
		return

	var player = audio_player.instantiate()

	player.stream = entry.stream
	player.volume_db = entry.get_volume()
	player.pitch_scale = 1.0 + randf_range(-entry.pitch_variance, entry.pitch_variance)
	player.global_position = position

	get_tree().root.add_child(player)

func play_music(key: StringName):
	var entry: AudioEntry = audio_library.music_library.get(key)
	if not entry:
		printerr("Error (Audio): Music key not found in library: ", key)
		return

	music_player.stream = entry.stream
	music_player.volume_db = entry.get_volume()
	music_player.play()

func get_player() -> AudioStreamPlayer:
	for player in sfx_pool:
		if is_instance_valid(player) and not player.is_playing():
			return player
	return null
