extends CharacterBody2D

var current_hp: int = 100

var attack_interval := 2.0
var can_attack := true

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	if can_attack:
		can_attack = false
		match randi() % 4:
			0:
				attack_one()
			1:
				attack_two()
			2:
				attack_three()
			4:
				attack_four()
		get_tree().create_timer(attack_interval).timeout.connect(func(): can_attack)

func attack_one() -> void:
	pass

func attack_two() -> void:
	pass

func attack_three() -> void:
	pass

func attack_four() -> void:
	pass

func take_damage(amount: int) -> void:
	current_hp -= 10
	print(current_hp)
