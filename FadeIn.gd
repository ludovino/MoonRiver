extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	var tween = create_tween()
	tween.tween_interval(0.75)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.75)
	tween.tween_callback(Callable(self, "queue_free"))
	tween.set_ease(Tween.EASE_IN)
