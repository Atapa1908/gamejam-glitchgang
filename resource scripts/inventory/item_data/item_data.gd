class_name ItemData
extends Resource

@export_category("Item Data")
@export_placeholder("Enter Name.") var name: String
@export_placeholder("Description.") var description: String
@export var stackable: bool = false
@export var texture: AtlasTexture

func use(target) -> void:
	pass
