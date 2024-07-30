extends CharacterBody2D

@onready var camera: Camera2D = $Camera
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var hit_box: Area2D = $HitBox
@onready var hit_box_area: CollisionShape2D = $HitBox/HitBoxArea

@onready var Projectile = preload("res://scenes/flask.tscn")
@onready var game = get_node("/root/Game")

@export var inventory_data: InventoryData
@export_range(0.1, 0.5, 0.01, "or_greater") var DEFAULT_DASH_TIME: float = 0.3

# Normalisation of effects for later
@export var effects: Dictionary = {}


## Move speed vars
const WALK_SPEED = 150.0
const DASH_SPEED = 350.0
const JUMP_VELOCITY = -300.0

var abilities: Dictionary = {
	"double_jump" : false,
	"dashing" : false,
	"sliding" : false,
	"gliding" : false,
}

## Physics vairs
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_dash: bool = true
var dashing: bool = false
var dash_timer: float
var last_whole_x_direction: int = 1

## Combat Variables
var max_hp: int = 100
var current_hp: int = 100
var player_alive: bool = true
var is_attacking: bool = false

## Double Jump Count
var jump_count = 0
var max_jumps = 1

func _ready() -> void:
	inventory_data.new_slot_data.connect(inv_updated)

func _physics_process(delta):
	print(abilities["double_jump"])
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
		velocity.x = last_whole_x_direction * DASH_SPEED
		move_and_slide()
		return
	
	if is_on_floor():
		jump_count = 0
	
	# Double Jump
	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	# Get the input direction to handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	
	# Changes the side the palyer is facing and saves the integer input of the direction
	if direction != 0:
		last_whole_x_direction = clamp(direction * 100, -1, 1)
		# NEEDS TO BE CHANGED IF HITBOX IS MOVED IN 2D
		hit_box.position.x = 8 * last_whole_x_direction
		animated_sprite.flip_h = last_whole_x_direction <= 0
	
	# Plays the correct animation
	if is_on_floor():
		if direction == 0 and is_attacking == false:
			animated_sprite.play("idle")
		elif direction !=0 and is_attacking == false:
			animated_sprite.play("walking")
	else:
		if is_attacking == false:
			animated_sprite.play("jumping")
	
	if direction:
		# Adds velocity to the player
		velocity.x = direction * WALK_SPEED
	else:
		# Decelerates the player
		velocity.x = move_toward(velocity.x, 0, WALK_SPEED)
	
	if Input.is_action_just_pressed("Attack"):
		animated_sprite.play("attack_basket")
		is_attacking = true
		hit_box_area.disabled = false
	
	if Input.is_action_just_pressed("interact"):
		ranged_attack()
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dash"):
		SceneManager.switch_realm(get_parent())

func ranged_attack():
	var projectile = Projectile.instantiate()
	game.add_child(projectile)
	projectile.position = position + Vector2(10 * last_whole_x_direction, -5)
	projectile.launch(last_whole_x_direction)

func _on_animated_sprite_animation_finished():
	if animated_sprite.animation == "attack_basket":
		hit_box_area.disabled = true
		is_attacking = false

# Handle mushroom consumption (primarily for now)
func inv_updated(slot_data: SlotData) -> void:
	if slot_data.item_data.name == "jump_mushroom":
		abilities["double_jump"] = true
		max_jumps = 2

func _on_hazard_detector_area_entered(area):
	current_hp -= 10
	print(current_hp)

func add_ability(ability: String) -> void:
	if not abilities.has(ability):
		return
	
	abilities[ability] = true
	
	# Pause motion, hide player sprite and play new spite frames for a short time
	
	# Play sound effect through scene manager
	
	SceneManager.play_effect_path("res://assets/audio/collect_thing.wav")
	
