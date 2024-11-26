extends Particles2D

func _ready() -> void:
	emitting = true
	var tween = create_tween()
	tween.tween_interval(0.4)
	tween.tween_callback(self, "queue_free")
