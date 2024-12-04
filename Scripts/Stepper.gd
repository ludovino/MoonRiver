extends AudioStreamPlayer


export var clip : AudioStream
export(float, 0.05, 1.0) var step_time : float
var timer : Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true

func step() -> void:
	if not timer.is_stopped():
		return
	timer.start(step_time)
	stream = clip
	play()
