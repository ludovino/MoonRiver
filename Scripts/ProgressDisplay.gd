class_name ProgressDisplay
extends HBoxContainer

func _ready() -> void:
	pass

func setup(current: int, maximum: int) -> void:
	var children = get_children().duplicate()
	for child in children:
		remove_child(child)
		child.queue_free()
	print("prog", current, " ", maximum)
	for i in range(maximum):
		var panel = Panel.new()
		panel.size_flags_horizontal = SIZE_EXPAND_FILL
		panel.size_flags_vertical = SIZE_EXPAND_FILL
		add_child(panel)
		if i >= current:
			panel.theme_type_variation = "Empty"
