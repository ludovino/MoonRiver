class_name InventoryItemData
extends Resource

export(String, MULTILINE) var layout_string : String
export var layout_resource: Resource

func get_layout() -> InventoryItemLayout:
	if layout_resource is InventoryItemLayout:
		return layout_resource as InventoryItemLayout
	return null
