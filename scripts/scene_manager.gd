extends Node

#var current_scene: String = ""
var last_door: String = "Door"
var backdrop = preload("res://scenes/Backdrop.tscn").instantiate()

func _ready():
	get_tree().current_scene.add_sibling.call_deferred(backdrop)

func transition(world_string: String, door_name: String) -> Error:
	last_door = door_name
	
	# Fade out
	
	get_tree().change_scene_to_file(world_string)
	
	return OK

func fade_in() -> void:
	pass
