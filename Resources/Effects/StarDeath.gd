extends GPUParticles2D

func _ready() -> void:
	emitting = true
	var tween = create_tween()
	tween.tween_interval(0.4)
	tween.tween_callback(Callable(self, "queue_free"))
