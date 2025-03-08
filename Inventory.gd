class_name Inventory
extends Control

@export var layout_string : String # (String, MULTILINE)
enum { INACTIVE, LOCKED, UNLOCKED }

@export var inactive_color : Color
@export var locked_color : Color
@export var unlocked_color : Color

# layout vars
var layout : PackedInt32Array
var height : int
var width : int

var items : Array[InventoryItem]

func _ready() -> void:
	layout = PackedInt32Array()
	items = []
	var panels = $GridContainer.get_children()
	var ly = layout_string.strip_escapes()
	height = layout_string.length() - ly.length()
	width = ly.length() / height
	layout.resize(ly.length())
	items.resize(ly.length())
	for c in range(layout.size()):
		var state = int(ly[c])
		layout[c] = state
		match state:
			INACTIVE: panels[c].modulate = inactive_color
			LOCKED: panels[c].modulate = locked_color
			UNLOCKED: panels[c].modulate = unlocked_color

func can_add_item(item : InventoryItem, loc : Vector2i) -> bool:
	var vec2iarray = item.data.layout.get_layout()
	for vec in vec2iarray:
		var idx = _vec2idx(loc+vec)
		if idx < 0 || idx >= items.size(): return false
		var locked = layout[idx] != UNLOCKED
		var occupied = items[idx] != null
		if locked or occupied: return false
	return true

func _vec2idx(vec : Vector2i) -> int:
	return height * vec.y + vec.x

func _idx2vec(idx : int) -> Vector2i:
	var vec = Vector2i()
	vec.y = idx / height
	vec.x = height - vec.y * height
	return vec

func add_item(item : InventoryItem, location : Vector2i) -> void:
	if not can_add_item(item, location): push_error("check and handle can add item before adding")
	for vec in item.data.layout.get_layout():
		var idx = _vec2idx(vec)
		items[idx] = item

func remove_item(item : InventoryItem) -> void:
	for i in items.size():
		if items[i] == item:
			items[i] = null
