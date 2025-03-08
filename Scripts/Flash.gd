extends Label

@export var flash_color : Color

func flash() -> void:
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE * 2.0, 0.1)
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	var color_tween = scale_tween.parallel()
	color_tween.tween_property(self, "modulate", flash_color, 0.1)
	color_tween.tween_property(self, "modulate", Color.WHITE, 0.4)
