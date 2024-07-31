extends CharacterBody2D

var current_hp: int = 100

func _physics_process(delta: float) -> void:
	pass

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
