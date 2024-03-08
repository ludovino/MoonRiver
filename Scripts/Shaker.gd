extends Node2D


var noise = OpenSimplexNoise.new()
export var frequency = 64.0
export var magnitude = 10.0
var time = 0.0
var origin: Vector2
func _ready() -> void:
	origin = position
	noise.seed = randi()
	noise.period = 10

func _process(delta: float) -> void:
	time += delta * frequency
	position = origin
	if magnitude > 0:
		var x = noise.get_noise_2d(time, 0)
		var y = noise.get_noise_2d(0, time)
		position += Vector2(x, y) * magnitude
