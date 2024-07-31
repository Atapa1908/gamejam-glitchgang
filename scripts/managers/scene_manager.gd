extends Node

#var current_scene: String = ""
# 
var wait_time: float = 1.5
var last_door: String = ""
var backdrop = preload("res://scenes/backdrop.tscn").instantiate()
var shadow_world: bool = false
var can_shadow: bool = false
var shadow_time: float = 3.0
var default_volume: float = 0.0:
	set(val):
		default_volume = clamp(val, 0.0, 200.0)
var first_time: bool = true
var radios: Array[AudioStreamPlayer]
var sound_effects: Array[AudioStreamPlayer]
var max_effects: int = 2
# Might seem misleading but, it gets set to false when the process function is looping a song
var looping: bool = true
var loop_start: float = 0.0
# A value of -1 means that the radio will loop at the end of the song
var loop_end: float = -1.0

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


func _ready():
	randomize()
	process_mode = Node.PROCESS_MODE_ALWAYS
	backdrop.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_sibling.call_deferred(backdrop)
	music_transition("main_menu")
	

func _process(delta: float) -> void:
	if not looping:
		return
	
	if loop_end > 0.0 and radios[0].get_playback_position() + delta * 2 >= loop_end:
		looping = false
		loop_song(radios[0].stream.get_length() - loop_end, loop_start)
	elif radios[0].get_playback_position() + delta * 2 >= radios[0].stream.get_length():
		looping = false
		loop_song(radios[0].stream.get_length() - radios[0].get_playback_position(), loop_start)

# Transitioning scenes
func transition(world_name: String, door_name: String) -> void:
	
	last_door = door_name
	
	fade_out()
	
	music_transition(world_name)
	
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
func music_transition(world_name: String, bgm: String = "") -> void:
	if bgm.is_empty():
		var bgms: Dictionary = worlds_data[world_name]["bgms"]
		
		if shadow_world and bgms.has("shadow"):
			bgm = bgms["shadow"]
		elif world_name.contains("menu"):
			bgm = bgms.values()[randi() % bgms.size()]
		else:
			bgm = bgms["light"]
	
	var position: float = loop_start
	if radios.size() > 0 and radios[0].get_stream().resource_path == bgm:
		position = radios[0].get_playback_position()
		
		for radio in radios:
			radio.volume_db = linear_to_db((default_volume / 2.0) / 200.0)
	
	var new_radio: AudioStreamPlayer = create_new_radio(bgm, default_volume / 2, position)
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
	

func loop_song(time_left: float, start_time: float = 0.0) -> void:
	radios.append(
		create_new_radio(
			radios[0].stream.resource_path,
			default_volume / 2,
			start_time
		)
	)
	
	get_tree().create_timer(0.02, true, false, true).timeout.connect(
		func():
			radios[1].volume_db = radios[0].volume_db
			radios[0].queue_free()
			radios.remove_at(0)
			looping = true
	)
	

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

# Sound effects

func play_effect_path(path: String) -> void:
	if not path.is_empty():
		return
	play_effect(load(path))

func play_rand_effect(effects: Array[AudioStreamWAV]) -> void:
	if effects.size() <= 0:
		return
	var temp_effect: AudioStreamWAV = effects[randi() % effects.size()]
	play_effect(temp_effect)

func play_effect(effect: AudioStreamWAV) -> void:
	if not effect:
		return
	if sound_effects.size() >= max_effects:
		sound_effects.remove_at(0)
	var temp_player: AudioStreamPlayer = AudioStreamPlayer.new()
	temp_player.stream = effect
	temp_player.volume_db = linear_to_db(1.0)
	add_child(temp_player)
	temp_player.play()
	sound_effects.append(temp_player)
	temp_player.finished.connect(
		func():
			sound_effects.erase(temp_player)
			temp_player.queue_free()
	)

# Shadow world transitioning

func switch_realm(world: Node2D) -> void:
	if not can_shadow:
		return
	
	# Switchces the 
	shadow_world = not shadow_world
	music_transition(world.name.to_snake_case())
	# Transition (quick so ~0.5s)
	# Asks the world to change the tile maps etc
	world.switch_realm()
	can_shadow = false
	get_tree().create_timer(shadow_time).timeout.connect(func(): can_shadow = true)
