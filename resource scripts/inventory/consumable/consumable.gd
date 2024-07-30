class_name Consumable
extends ItemData

@export_category("Consumable Data")
@export_range(1.0, 10.0, 1.0, "or_greater") var potency: float
@export var sound_effects: Array[AudioStreamWAV]

func use(target) -> void:
	SceneManager.play_rand_effect(sound_effects)
	# Do thing
