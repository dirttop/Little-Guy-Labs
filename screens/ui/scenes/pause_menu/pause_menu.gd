extends Control


func _on_resume_button_pressed() -> void:
	PauseManager.toggle_pause()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
