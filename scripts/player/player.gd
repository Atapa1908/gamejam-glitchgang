extends CharacterBody2D

@onready var camera: Camera2D = $Camera
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var hit_box: Area2D = $HitBox
@onready var hit_box_area: CollisionShape2D = $HitBox/HitBoxArea

# Stores all the abilities that the player has as a list of enumerates
# NOTE: 
# You don't need to implement this straight away
# Figure out how the mechanic should work first
@export var abilities: Array[PlayerManager.abilities]
@export var inventory_data: InventoryData
@export_range(0.1, 0.5, 0.01, "or_greater") var DEFAULT_DASH_TIME: float = 0.3

const WALK_SPEED = 300.0
const DASH_SPEED = 500.0
const JUMP_VELOCITY = -400.0

## Physics vairables
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dashing: bool = false
var dash_timer: float
var last_x_direction: int = 1

## Combat Variables
var max_hp: int = 10
var current_hp: int = 10
var player_alive: bool = true
var is_attacking: bool = false

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	# Decrement dash timer
	dash_timer -= delta
	dash_timer = clamp(dash_timer, 0, DEFAULT_DASH_TIME)
	
	# Chacks to see if the user wants to and can dash
	if is_zero_approx(dash_timer) and \
		Input.is_action_just_pressed("dash"):
		dashing = true
		dash_timer = DEFAULT_DASH_TIME
		print(dash_timer)
	
	# Actually makes the user dash
	if dashing and not is_zero_approx(dash_timer):
		# * 100 turns 0.02 into 2
		# The clamp turns 2 into 1
		var dash_direction: int = clamp(last_x_direction * 100.0, -1, 1)
		velocity.x = dash_direction * DASH_SPEED
		print("%s : %s" % [last_x_direction, dash_direction])
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		last_x_direction = direction
	
	if direction > 0:
		animated_sprite.flip_h = false
		# NEEDS TO BE SWITCHED IF HITBOX IS MOVED IN 2D
		hit_box.position.x = 8
	elif direction < 0:
		animated_sprite.flip_h = true
		hit_box.position.x = -8
	
	if is_on_floor():
		if direction == 0 and is_attacking == false:
			animated_sprite.play("idle")
		elif direction !=0 and is_attacking == false:
			animated_sprite.play("walking")
	else:
		if is_attacking == false:
			animated_sprite.play("jumping")
	
	if direction:
		velocity.x = direction * WALK_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	
	if Input.is_action_just_pressed("Attack"):
		animated_sprite.play("attack_basket")
		is_attacking = true
		hit_box_area.disabled = false
	
	move_and_slide()

func _on_animated_sprite_animation_finished():
	if animated_sprite.animation == "attack_basket":
		hit_box_area.disabled = true
		is_attacking = false

# NOTE POTENTIALLY LEGACY
# Esta needs to inspect
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










