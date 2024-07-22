extends CharacterBody2D

@onready var camera: Camera2D = $Camera
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


@export var inventory_data: InventoryData
@export_range(0.1, 0.5, 0.01, "or_greater") var DEFAULT_DASH_TIME: float = 0.3

var abilities: Dictionary = {
	"double jump" : false
}

## Move speed vars
const WALK_SPEED = 300.0
const DASH_SPEED = 500.0
const JUMP_VELOCITY = -400.0

## Physics vairs
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dashing: bool = false
var dash_timer: float
var last_whole_x_direction: int = 1

## Combat Vars
var max_hp = 10
var current_hp = 10
var player_alive = true

## Double Jump Count
var jump_count = 0
var max_jumps = 1
var mushroom_active = false
var default_mushroom_timer = 10.0
var mushroom_timer = 0.0
var consume_mushroom = true

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
	
	# Actually makes the user dash
	if dashing and not is_zero_approx(dash_timer):
		# * 100 turns 0.02 into 2
		# The clamp turns 2 into 1
		var dash_direction: int = last_whole_x_direction
		velocity.x = dash_direction * DASH_SPEED
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Mushroom Effect timer
	if mushroom_active:
		mushroom_timer -= delta
		if mushroom_timer >= 0.0:
			mushroom_active = false 
			max_jumps = 1
		
	
	# Double Jump
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		
	if is_on_floor():
		jump_count = 0 
	
	consume_jump_mushroom()
	
	# Get the input direction to handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	# Changes the side the palyer is facing and saves the integer input of the direction
	if direction != 0:
		last_whole_x_direction = clamp(direction * 100, -1, 1) <= 0
		animated_sprite.flip_h = last_whole_x_direction
	
	# Plays the correct animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	else:
		animated_sprite.play("jumping")
	
	if direction:
		# Adds velocity to the player
		velocity.x = direction * WALK_SPEED
	else:
		# Decelerates the player
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	
	move_and_slide()

func consume_jump_mushroom():
	mushroom_active = true
	max_jumps = 2
	mushroom_timer = 0.0
	
	
