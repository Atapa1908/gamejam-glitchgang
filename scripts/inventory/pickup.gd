extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var slot_data: SlotData

func _ready() -> void:
	sprite.sprite_frames = slot_data.item_data.sprite_frames

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.inventory_data.pick_up_slot_data(slot_data):
		queue_free()
	
func _init() -> void:
	collision_layer = 0
	collision_mask = 2

# NOTE THIS IS NOT A REQUIREMENT #
# Check if quantity is greater than 2 then add 1 more sprite
# Check if quantity is greater than ~10 then add another sprite 
# You can have all 3 preloaded / connected to the scene but hiding
