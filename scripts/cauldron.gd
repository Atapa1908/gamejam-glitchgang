extends Area2D

@export var ability_name: String = ""
@export var sprite_path: String = ""

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if sprite_path.is_empty():
		return
	sprite_2d.texture = load(sprite_path)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var temp_inv: InventoryData = body.inventory_data
		
