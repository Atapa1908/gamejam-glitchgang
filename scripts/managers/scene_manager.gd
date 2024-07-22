extends Node

#var current_scene: String = ""
var wait_time: float = 2.0
var last_door: String = "Door"
var backdrop = preload("res://scenes/backdrop.tscn").instantiate()

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	backdrop.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_sibling.call_deferred(backdrop)

func transition(world_string: String, door_name: String) -> void:
	last_door = door_name
	
	fade_out()
	
	get_tree().change_scene_to_file.call_deferred(world_string)
	
	fade_in()
	

func fade_out() -> void:
	backdrop.show()
	get_tree().paused = true
	Engine.time_scale = 0.0

func fade_in() -> void:
	await get_tree().create_timer(wait_time, true, false, true).timeout
	backdrop.hide()
	Engine.time_scale = 1.0
	get_tree().paused = false
