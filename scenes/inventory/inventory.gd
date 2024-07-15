extends PanelContainer

@onready var item_grid: GridContainer = %ItemGrid

@export var packed_slot: PackedScene

func set_inventory_data(inv_data: InventoryData) -> void:
	inv_data.inv_updated.connect(populate_grid)
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
