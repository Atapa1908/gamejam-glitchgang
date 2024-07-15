extends CharacterBody2D

# NOTE
# Might need to move some base functions into a base class

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var camera: Camera2D = $Camera

@export_category("Statistics")
@export var MAX_HEALTH: float = 10.0

@export_category("Movement")

@export_category("Inventory")
@export var inventory: InventoryData

var health: float = MAX_HEALTH

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	velocity = direction * 200.0
	
	move_and_slide()

func heal(heal_value: float) -> void:
	health += heal_value
	clamp(health, 0.0, MAX_HEALTH)
	print("Healed player by %s to %s" % [heal_value, health])
