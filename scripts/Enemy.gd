extends CharacterBody2D
var player_ref
const speed = 150.0 

var current_hp: int = 100
var player_attacks: bool = false
var attack_interval = 1.0 
var can_attack = true 

func take_damage(amount: int) -> void:
	current_hp -= 10
	print(current_hp)

func _physics_process(delta):
	if can_attack and player_ref:
		#inst
		var temp_ball = load("res://scenes/projectile.tscn").instantiate() as AnimatableBody2D
		get_parent().add_child(temp_ball)
		temp_ball.constant_linear_velocity = Vector2.ONE * speed
		temp_ball.look_at(player_ref.global_position)
		can_attack = false
		get_tree().create_timer(attack_interval).timeout.connect(func(): can_attack = true )


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
