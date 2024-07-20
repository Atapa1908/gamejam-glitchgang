extends Node

# Does not include main menu
#var current_scene: String = ""

var last_door: String = "Door"
var backdrop = preload("").instantiate()

func _ready() -> void:
	pass

func transition(world_string: String, door_name: String) -> Error:
	last_door = door_name
	
	get_tree().change_scene_to_file(world_string)
	
	return OK
