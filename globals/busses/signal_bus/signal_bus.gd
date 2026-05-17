extends Node

## World Management Signals
signal request_next
signal load_next
signal loaded
signal next_ready

## UI Management Signals
signal saving
signal saved
signal enter_level(level_data)
signal exit_level
signal artifact_collected(index)

## Game Management Signals
signal new_game
