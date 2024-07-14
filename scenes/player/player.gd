extends CharacterBody2D

# NOTE
# Might need to move some base functions into a base class

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var camera: Camera2D = $Camera

@export_category("Statistics")

@export_category("Movement")


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	
	velocity = direction * 200.0

func heal(_heal_value: float) -> void:
	print("Healing.")
