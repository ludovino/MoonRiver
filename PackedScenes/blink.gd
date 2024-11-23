extends CanvasItem

export var time : float

func _ready() -> void:
	time = clamp(time, 0.1, 10.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate",Color.transparent, time * 0.5)
	tween.tween_property(self, "modulate",Color.white, time * 0.5)
	tween.set_loops()
