class_name AnimatedSpriteRng
extends AnimatedSprite2D

func _ready() -> void:
	speed_scale = speed_scale * (0.5 + randf())
	var count = sprite_frames.get_frame_count(animation)
	frame = randi() % count
