extends CharacterBody2D


var current_hp: int = 100
var player_attacks: bool = false

func take_damage(amount: int) -> void:
	current_hp -= 20
	print(current_hp)



