class_name River
extends Node2D

export var speed: float

func _process(delta: float) -> void:
	for star in get_children():
		star.position += Vector2.UP * speed * delta
