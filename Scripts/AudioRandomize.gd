extends AudioStreamPlayer2D

export(float, 0.0, 0.5, 0.01) var random_range : float

func _ready() -> void:
	var offset = random_range * 0.5
	pitch_scale += rand_range(-offset , offset)
