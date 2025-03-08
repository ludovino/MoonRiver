extends Node2D


@export var turns_per_second : float

func _process(delta: float) -> void:
	rotation += turns_per_second * 2 * PI * delta
