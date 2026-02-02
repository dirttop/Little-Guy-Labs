@tool
extends Resource
class_name AudioLibrary

#gleb: key value pairs (name, path)
@export var sfx_library: Dictionary[String, AudioEntry] = {}
@export var music_library: Dictionary[String, AudioEntry] = {}
