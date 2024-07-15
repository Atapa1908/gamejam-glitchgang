extends StaticBody2D

@onready var sprite: Sprite2D = $AnimatedSprite2D

@export var slot_data: SlotData

func _ready() -> void:
	sprite.texture = slot_data.item_data.icon

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.inventory.pick_up_slot_data(slot_data):
		queue_free()
	
