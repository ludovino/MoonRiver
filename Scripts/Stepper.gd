extends AudioStreamPlayer2D


@export var step_time : float # (float, 0.05, 1.0)
@export var random_range : float # (float, 0.0, 0.5, 0.01)
var initial_pitch : float

var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	initial_pitch = pitch_scale

func step() -> void:
	if not timer.is_stopped():
		return
	timer.start(step_time)
	randomize_pitch()
	play()

func randomize_pitch() -> void:
	var offset = random_range * 0.5
	pitch_scale = initial_pitch + randf_range(-offset , offset)
