class_name Alert
extends AudioStreamPlayer


@export var enabled : bool = false
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.start(1.2)
	timer.connect("timeout", Callable(self, "play_if_enabled"))

func play_if_enabled() -> void:
	if enabled: play()
