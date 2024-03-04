class_name Star
extends Area2D

export var pulse_speed: float
export var pulse_graph: Curve
export var score: int
export var escape_speed: float
export var magnitude: float
export(float, 0, 1.0) var reel_speed_mod: float = 0.9

var time: float
var intensity: float

func _process(delta: float) -> void:
	time += delta * pulse_speed
	if time >= 1.0:
		time -= 1.0
	intensity = pulse_graph.interpolate(time)
