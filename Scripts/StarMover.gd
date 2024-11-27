extends Area2D


export var direction : Vector2
export var magnitude : float
export var local : bool
export var point : bool
export(float, EASE) var falloff : float
export(float) var min_distance : float
export(float) var max_distance : float

func _process(delta: float) -> void:
	var areas = get_overlapping_areas()
	for star in areas:
		if star.is_in_group("star") or star.is_in_group("lure"):
			if point: _move_point(star, delta)
			else: _move_direction(star, delta)

func _move_point(node : Node2D, delta: float) -> void:
	if node.name == "lure": print("LURE MOVED??")
	var dir : Vector2
	if local:
		 dir = global_position + direction - node.global_position
	else:
		dir = direction - node.global_position
	var total = max_distance - min_distance
	var decay = clamp((total - dir.length()) / total, 0.0, 1.0)
	node.global_position += dir.normalized() * magnitude * delta * ease(decay, falloff)

func _move_direction(node : Node2D, delta: float) -> void:
	if node.name == "lure": print("LURE MOVED??")
	var dir : Vector2
	if local:
		dir = direction.rotated(global_rotation)
	else:
		dir = direction
	node.global_position += dir.normalized() * magnitude * delta
