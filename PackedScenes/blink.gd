extends CanvasItem

@export var time : float

func _ready() -> void:
	time = clamp(time, 0.1, 10.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate",Color.TRANSPARENT, time * 0.5)
	tween.tween_property(self, "modulate",Color.WHITE, time * 0.5)
	tween.set_loops()
