extends PanelContainer

signal use_item(index: int)

@onready var item_grid: GridContainer = %ItemGrid

@export var packed_slot: PackedScene

# _unhandled_key_input doesn't allow any controller inputs so change for _unhandled_input later and connect all the controller controls
func _unhandled_key_input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	
	if range(KEY_1, KEY_8).has(event.keycode):
		use_item.emit(event.keycode - KEY_1)

func set_inventory_data(inv_data: InventoryData) -> void:
	inv_data.inv_updated.connect(populate_grid)
	use_item.connect(inv_data.use_slot)
	populate_grid(inv_data)

func clear_inventory_data(inv_data: InventoryData) -> void:
	inv_data.inv_updated.disconnect(populate_grid)

func populate_grid(inv_data: InventoryData) -> Error:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data: SlotData in inv_data.data:
		var inst_slot: PanelContainer = packed_slot.instantiate()
		item_grid.add_child(inst_slot)
		
		inst_slot.clicked.connect(inv_data.on_slot_clicked)
		
		if slot_data:
			inst_slot.set_slot_data(slot_data)
		
	return OK
