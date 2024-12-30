class_name InventoryItemLayout
extends Resource

export(String, MULTILINE) var layout_string : String
export var layout_bg : Texture

func get_layout() -> Array:
	var layout = []
	var ly = layout_string.strip_escapes()
	var height = layout_string.length() - ly.length()
	var width = ly.length() / height
	for i in range(ly.length()):
		if ly[i] == "0":
			continue
		var vec = Vector2i.new()
		vec.x = i % width
		vec.y = i / height
		layout.append(vec)
	return layout

class Vector2i:
	var x : int
	var y : int
