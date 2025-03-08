extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event is InputEventKey:
		if event.physical_keycode != KEY_QUOTELEFT or not event.is_pressed() or event.is_echo():
			return
		var tree = get_tree()
		tree.paused = not tree.paused 
