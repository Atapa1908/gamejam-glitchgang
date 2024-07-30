extends RigidBody2D

const SPEED = 300
var direction: Vector2 = Vector2.ZERO
var gravity_flask = ProjectSettings.get_setting("physics/2d/default_gravity") / 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", self._on_body_entered)
	
func _init() -> void:
	collision_layer = 0
	collision_mask = 2


func launch(temp_direction):
	var X = sin(45) * SPEED * temp_direction
	var Y = -cos(45) * SPEED
	
	linear_velocity = Vector2(X, Y)
	

func _on_body_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
		
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
