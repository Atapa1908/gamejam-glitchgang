extends CharacterBody2D

var current_hp: int = 100

func take_damage(amount: int) -> void:
	current_hp -= 10
	print(current_hp)
