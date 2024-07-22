extends Area2D

@export_file var scene: String
@export var scene_door_name: String

func _on_body_entered(body: Node2D) -> void:
	if Engine.is_editor_hint():
		return
	if body.is_in_group("player"):
		SceneManager.transition(scene, scene_door_name)
