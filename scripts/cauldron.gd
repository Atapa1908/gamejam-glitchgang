extends Area2D

@export var ability_name: String = ""
@export var fruit: Fruit

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if fruit:
		return
	sprite_2d.texture = fruit.texture

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	
	var temp_inv: InventoryData = body.inventory_data
	var fruit_counter: int = 0
	var fruits: Array[SlotData]
	for slot in temp_inv.data:
		if not slot:
			continue
		if not slot.item_data is Fruit:
			continue
		
		fruit_counter += slot.quantity
		fruits.append(slot)
	
	if fruit_counter < 3:
		return
	
	for slot in fruits:
		if fruit_counter >= 0:
			if slot.quantity >= fruit_counter:
				temp_inv.remove_slot_data(temp_inv.data.find(slot), fruit_counter)
				fruit_counter = 0
			elif fruit_counter > 0:
				var temp_var: int = fruit_counter % slot.quantity
				temp_inv.remove_slot_data(temp_inv.data.find(slot), temp_var)
				fruit_counter = temp_var
		if fruit_counter == 0:
			body.add_ability(ability_name)
			return
		
	
