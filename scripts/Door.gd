extends Area2D

@export var scene_name: String
@export var scene_door_name: String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.transition(scene_name, scene_door_name)
