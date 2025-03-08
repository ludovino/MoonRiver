class_name ReelsDisplay
extends GridContainer

@export var texture: Texture2D

signal lose_reel

var current: int = 0

func adjust(new_count: int):
	print("c",current)
	print("n",new_count)
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
	var tween = create_tween()
	var color = Color(1.0, 0.0, 0.0, 0.1)
	
	for i in range(0, count):
		var reel = reels[high_index -i]
		tween.tween_property(reel,"modulate", color, 0.2)
		tween.parallel().tween_property(reel, "scale", Vector2.ONE * 1.3, 0.3)
		tween.tween_callback(Callable(reel, "queue_free"))
		emit_signal("lose_reel")
		
