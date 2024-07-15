extends StaticBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var slot_data: SlotData

func _ready() -> void:
	sprite.sprite_frames = slot_data.item_data.sprite_frames

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.inventory.pick_up_slot_data(slot_data):
		queue_free()
	
