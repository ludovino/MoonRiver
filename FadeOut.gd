extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 1.6)
	tween.set_ease(Tween.EASE_IN)
