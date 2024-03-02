class_name Star
extends Area2D

export var pulse_speed: float
export var pulse_graph: Curve
export var pulse_gradient: Gradient
export var score: int
var time: float
var intensity: float

func _process(delta: float) -> void:
	time += delta * pulse_speed
	if time >= 1.0:
		time -= 1.0
	intensity = pulse_graph.interpolate(time)
	$Sprite.modulate = pulse_gradient.interpolate(intensity)
