class_name InventoryItemLayout
extends Resource

@export_multiline var layout_string : String
@export var layout_bg : Texture2D

func get_layout() -> Array[Vector2i]:
	var layout = []
	var ly = layout_string.strip_escapes()
	var height = layout_string.length() - ly.length()
	var width = ly.length() / height
	for i in range(ly.length()):
		if ly[i] == "0":
			continue
		var vec = Vector2i(i % width, i / height)
		layout.append(vec)
	return layout
