extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
