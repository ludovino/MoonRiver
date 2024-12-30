class_name Inventory
extends Control

export(String, MULTILINE) var layout_string : String
enum { INACTIVE, LOCKED, UNLOCKED }

export var inactive_color : Color
export var locked_color : Color
export var unlocked_color : Color

# layout vars
var layout : PoolIntArray
var height : int
var width : int

func _ready() -> void:
	layout = PoolIntArray()
	var panels = $GridContainer.get_children()
	var ly = layout_string.strip_escapes()
	height = layout_string.length() - ly.length()
	width = ly.length() / height
	layout.resize(ly.length())
	for c in range(layout.size()):
		var state = int(ly[c])
		layout[c] = state
		match state:
			INACTIVE: panels[c].modulate = inactive_color
			LOCKED: panels[c].modulate = locked_color
			UNLOCKED: panels[c].modulate = unlocked_color

#func add_item(item : InventoryItem) -> void:
#	pass
