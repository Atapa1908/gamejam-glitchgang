extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var player: CharacterBody2D = $Player
@onready var inventory_interface: Control = %InventoryInterface
@onready var player_inventory: PanelContainer = %PlayerInventory
@onready var items: Node2D = $Items

@export var packed_pickup: PackedScene

func _ready() -> void:
	inventory_interface.force_close.connect(toggle_inventory)
	inventory_interface.set_player_inventory_data(player.inventory)
	inventory_interface.set_equipment_inventory_data(player.equipment_inventory)
	

func toggle_inventory() -> void:
	inventory_interface.clear_ext_inv()

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	var pickup := packed_pickup.instantiate()
	pickup.name = slot_data.item_data.name
	pickup.slot_data = slot_data
	pickup.global_position = player.global_position + Vector2(30, 5) * player.direction_buffer
	items.add_child(pickup)
