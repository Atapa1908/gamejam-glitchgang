class_name ItemData
extends Resource

@export_category("Item Data")
@export_placeholder("Enter Name.") var name: String
@export_multiline var description: String
@export var stackable: bool = false
@export var texture: Texture2D
@export var sprite_frames: SpriteFrames

func use(target) -> void:
	print("Yay")
