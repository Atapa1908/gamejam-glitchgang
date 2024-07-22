extends Node

var player_ref: CharacterBody2D

func use_slot_data(slot_data: SlotData) -> void:
	slot_data.item_data.use(player_ref)

func get_player_global_position() -> Vector2:
	return player_ref.global_position

