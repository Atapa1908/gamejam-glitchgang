class_name InventoryData
extends Resource

signal inv_interact(inv_data: InventoryData, index: int, button: int)
signal inv_updated(inv_data: InventoryData)

@export_category("Slots")
@export var data: Array[SlotData]

func on_slot_clicked(index: int, button: int) -> void:
	inv_interact.emit(self, index, button)

func grab_slot_data(index: int) -> SlotData:
	var slot_data: SlotData = data[index]
	
	if slot_data:
		data[index] = null
		inv_updated.emit(self)
	
	return slot_data

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data: SlotData = data[index]
	
	var return_slot_data: SlotData
	
	if slot_data and slot_data.can_fully_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data)
	else:
		data[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inv_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	var slot_data: SlotData = data[index]
	
	if not slot_data:
		data[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inv_updated.emit(self)
	
	return grabbed_slot_data if grabbed_slot_data.quantity > 0 else null

func pick_up_slot_data(slot_data: SlotData) -> bool:
	var first_null: int = -1
	
	for index in data.size():
		if data[index] and data[index].can_fully_merge_with(slot_data):
			data[index].fully_merge_with(slot_data)
			inv_updated.emit(self)
			return true
		
		if not data[index] and first_null == -1:
			first_null = index
		
	
	if first_null > -1:
		data[first_null] = slot_data
		inv_updated.emit(self)
		return true
	
	return false

func use_slot(index: int) -> void:
	var slot_data: SlotData = data[index]
	if not slot_data:
		return
	
	if slot_data.item_data is Consumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			data[index] = null
	
	PlayerManager.use_slot_data(slot_data)
	
	inv_updated.emit(self)
