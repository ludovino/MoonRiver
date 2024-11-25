extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.transparent
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.black, 1.6)
	tween.set_ease(Tween.EASE_IN)
