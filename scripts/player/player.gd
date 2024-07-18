extends CharacterBody2D

## Combat variables

var max_hp = 10
var cur_hp = 10
var player_alive = true

@export var inventory_data: InventoryData

const SPEED = 130.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	else:
		animated_sprite.play("jumping")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#func _process(delta):
	#if Input.is_action_just_pressed("attack"):
		#$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = false
		#$AnimatedSprite2D.animation = "attack"
	#else:
		#$AnimatedSprite2D/Area2D/CollisionShape2D.disabled = true
#
#func _on_area_2d_body_entered(body):
	#if body.is_in_group("hit"):
		#body.take_damage()
	#else:
		#pass

