class_name ReelsDisplay
extends GridContainer

export(Texture) var texture: Texture
export var initial_count: int = 3
var current: int = 0

func _ready() -> void:
	adjust(initial_count)

func adjust(new_count: int):
	var x = new_count - current
	current = new_count
	if x > 0:
		add_reels(x)
	if x < 0:
		remove_reels(-x)

func _on_Main_hooks_change(hooks: int) -> void:
	adjust(hooks)
		
func add_reels(count: int):
	for _i in range(0, count):
		var reel = TextureRect.new()
		reel.texture = texture
		add_child(reel)
		
func remove_reels(count: int):
	var reels = get_children()
	var high_index = get_child_count() -1
	for i in range(0, count):
		reels[high_index -i].queue_free()
