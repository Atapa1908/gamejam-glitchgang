class_name SlotData
extends Resource

const MAX_STACK_SIZE: int = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1:
	set(v):
		if not item_data.stackable:
			push_warning("Item %s is not stackable, value set to 1." % [item_data.name])
			v = 1
		quantity = v

func can_merge_with(other_slot_data: SlotData) -> bool:
	return other_slot_data.item_data == item_data \
		and item_data.stackable \
		and quantity < MAX_STACK_SIZE

func can_fully_merge_with(other_slot_data: SlotData) -> bool:
	return other_slot_data.item_data == item_data \
		and item_data.stackable \
		and quantity + other_slot_data.quantity <= MAX_STACK_SIZE

func fully_merge_with(other_slot_data: SlotData) -> void:
	quantity += other_slot_data.quantity

func create_single_slot_data() -> SlotData:
	var new_slot_data: SlotData = duplicate()
	new_slot_data.quantity = 1
	quantity -= 1
	return new_slot_data
