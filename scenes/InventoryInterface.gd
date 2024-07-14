extends Control

signal drop_slot_data(slot_data: SlotData)
signal force_close

@onready var player_inventory: PanelContainer = %PlayerInventory
@onready var grabbed_slot: PanelContainer = %GrabbedSlot

var grabbed_slot_data: SlotData
var extra_inv_owner

func _physics_process(_delta: float) -> void:
	if grabbed_slot_data:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2.ONE * 10
	

func set_player_inventory_data(inv_data: InventoryData) -> void:
	inv_data.inv_interact.connect(on_inv_interact)
	player_inventory.set_inventory_data(inv_data)

func on_inv_interact(inv_data: InventoryData, index: int, button: int) -> void:
	
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inv_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inv_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			inv_data.use_slot(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inv_data.drop_single_slot_data(grabbed_slot_data, index)
		
	 
	update_grabbed_slot()
	

func update_grabbed_slot() -> void:
	if not grabbed_slot_data:
		grabbed_slot.hide()
		return
	
	grabbed_slot.show()
	grabbed_slot.set_slot_data(grabbed_slot_data)
	

func _on_gui_input(event: InputEvent) -> void:
	if not grabbed_slot_data or not event is InputEventMouseButton:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
		if grabbed_slot_data.quantity <= 0:
			grabbed_slot_data = null
		update_grabbed_slot()
