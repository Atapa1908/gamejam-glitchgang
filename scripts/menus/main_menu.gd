extends Control

func _on_start_pressed() -> void:
	# Call the scene manager and transition to game scene
	SceneManager.transition("res://scenes/game.tscn", SceneManager.last_door)

func _on_quit_pressed() -> void:
	get_tree().quit()
