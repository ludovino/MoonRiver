class_name AnimatedSpriteRng
extends AnimatedSprite

func _ready() -> void:
	speed_scale = speed_scale * (0.5 + randf())
	var count = frames.get_frame_count(animation)
	frame = randi() % count
