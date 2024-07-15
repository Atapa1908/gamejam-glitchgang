extends PanelContainer

signal clicked(index: int, button: int)

@onready var item_texture: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $MarginContainer/Label

func set_slot_data(slot_data: SlotData) -> void:
	var item_data: ItemData = slot_data.item_data
	item_texture.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	 
	quantity_label.text = "x%s" % slot_data.quantity
	quantity_label.visible = slot_data.quantity > 1
	

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
		and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT] \
		 and event.is_pressed():
		clicked.emit(get_index(), event.button_index)
