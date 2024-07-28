extends Node2D

@onready var items: Node2D = $Items
@onready var player: CharacterBody2D = $Player
@onready var doors: Node2D = $Doors
@onready var tilemap: TileMap = $Tilemap
@onready var inventory_interface: Control = %InventoryInterface

@export var packed_pickup: PackedScene

func _ready() -> void:
	SceneManager.fade_in()
	if not SceneManager.first_time:
		transition(SceneManager.last_door)
	inventory_interface.set_player_inventory_data(player.inventory_data)

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pickup := packed_pickup.instantiate()
	pickup.name = slot_data.item_data.name
	pickup.slot_data = slot_data
	# NOTE: the next line controls the placement of the item that is to be dropped
	pickup.global_position = player.global_position + Vector2(128, 0)
	items.add_child(pickup)

func transition(door_name: String) -> void:
	SceneManager.first_time = false
	var door: Area2D = doors.find_child(door_name)
	player.global_position = \
		door.get_node("Marker2D").global_position

func switch_realm() -> void:
	var temp: bool = tilemap.is_layer_enabled(0)
	tilemap.set_layer_enabled(0, not temp)
	tilemap.set_layer_enabled(1, temp)
