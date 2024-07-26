extends Node

#var current_scene: String = ""
# 
var wait_time: float = 1.5
var last_door: String = ""
var backdrop = preload("res://scenes/backdrop.tscn").instantiate()
var shadow_world: bool = false
var default_volume: float = 25.0:
	set(val):
		default_volume = clamp(val, 0.0, 200.0)

var radios: Array[AudioStreamPlayer]
# Might seem misleading but, it gets set to false when the process function is looping a song
var looping: bool = true

var worlds_data: Dictionary = {
	"game": {
		"world_scene_path": "res://scenes/game.tscn",
		"inst_doors": [ # Potential doors to be found at runtime
			"Door",
		],
		"bgms": {
			"light": "res://assets/BGM/light_forest_test.wav",
			"shadow" : "res://assets/BGM/dark_forest_test.wav",
		}
	},
	"main_menu": {
		"world_scene_path": "res://scenes/menus/main_menu.tscn",
		"inst_doors": [],
		"bgms": {
			"temp": "res://assets/BGM/Forest_01_wav.wav",
		}
	},
}
#worlds_data["game]["bgms]
# Template:
#var worlds_data: Dictionary = {
#	"world_name": {
#		"world_scene_path": "scene_path",
#		"inst_doors": [ # Potential doors to be found at runtime
#			"Door1"
#		],
#		"bgms": {
#			"bgm_nick_name": "test_bgm_path"
#		}
#	},
#}

func _ready():
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	backdrop.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_sibling.call_deferred(backdrop)
	radios.append(
		create_new_radio(
			worlds_data["main_menu"]["bgms"].values()[randi() % worlds_data["main_menu"]["bgms"].size()],
			default_volume
			)
		)
	

func _process(delta: float) -> void:
	#print(
		#"%s\n%s : %s : %s" % \
		#[
			#radios[0].stream.resource_path,
			#radios[0].stream.get_length(),
			#radios[0].get_playback_position(),
			#0.0 if radios.size() <= 1 else db_to_linear(radios[1].volume_db) * 2
		#]
	#)
	if radios[0].get_playback_position() + delta * 2 >= radios[0].stream.get_length() and looping:
		looping = false
		loop_song(radios[0].stream.get_length() - radios[0].get_playback_position())

# Transitioning scenes
func transition(world_name: String, door_name: String) -> void:
	if not "main_menu" and door_name in worlds_data[world_name]["doors"]:
		return
	
	last_door = door_name
	
	fade_out()
	
	music_transition(worlds_data[world_name]["bgms"], world_name)
	
	get_tree().change_scene_to_file.call_deferred(worlds_data[world_name]["world_scene_path"])
	
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

# Music

#
func music_transition(bgms: Dictionary, world_name: String) -> void:
	var new_bgm: String
	if shadow_world:
		new_bgm = bgms["shadow"]
	elif world_name.contains("menu"):
		new_bgm = bgms.values()[randi() % bgms.size()]
	else:
		new_bgm = bgms["light"]
	var position: float = 0.0
	if radios.size() > 0 and radios[0].get_stream().resource_path == new_bgm:
		position = radios[0].get_playback_position()
	# Create a new radio for transitioning
	
	for radio in radios:
		radio.volume_db = linear_to_db(default_volume / 200.0)
	
	var new_radio: AudioStreamPlayer = create_new_radio(new_bgm, default_volume / 2, position)
	radios.append(new_radio)
	
	get_tree().create_timer(0.3, true, false, true).timeout.connect(
		func():
			for radio in radios:
				if radio != new_radio:
					radio.queue_free()
			radios.clear()
			new_radio.volume_db = linear_to_db(default_volume / 200.0)
			radios.append(new_radio)
	)
	
	# Do transition
	

func loop_song(time_left: float) -> void:
	radios.append(
		create_new_radio(
			radios[0].stream.resource_path,
			db_to_linear(radios[0].volume_db) / 2
		)
	)
	
	get_tree().create_timer(time_left, true, false, true).timeout.connect(
		func():
			radios[1].volume_db = radios[0].volume_db
			radios[0].queue_free()
			radios.remove_at(0)
	)
	
	looping = true

func clear_radios() -> void:
	for radio in radios:
		radio.queue_free()
	radios.clear()

func create_new_radio(new_bgm: String, volume: float, position: float = 0.0) -> AudioStreamPlayer:
	var new_radio: AudioStreamPlayer = AudioStreamPlayer.new()
	# Connect the BGM song
	new_radio.stream = load(new_bgm)
	# Converts linear percent from (1-200) into decibels (+-~80)
	# To conserve eardrums I have changed the scale from 1%-100% to 1%-200%
	var temp_volume: float = linear_to_db(volume / 200.0)
	new_radio.volume_db = temp_volume
	# Needed to start playing songs when node is instantiated
	new_radio.autoplay = true
	# The Song cannot play if the node doesn't get put in the tree
	self.add_child(new_radio)
	# Sometimes you'll want to change the position like with changing from shadow to light etc
	new_radio.seek(position)
	
	return new_radio

# Shadow world transitioning

func switch_realm(world: Node2D) -> void:
	# Switchces the 
	shadow_world = not shadow_world
	music_transition(worlds_data[world.name.to_snake_case()]["bgms"], world.name.to_snake_case())
	# Transition (quick so ~0.5s)
	# Asks the world to change the tile maps etc
	world.switch_realm()
