extends Control

func _on_start_pressed() -> void:
	# Call the scene manager and transition to game scene
	SceneManager.transition("game", "Door")

func _on_quit_pressed() -> void:
	get_tree().quit()
