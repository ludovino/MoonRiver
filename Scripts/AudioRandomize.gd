tool
class_name AudioRandomize
extends Node

export(float, 0.0, 0.5, 0.01) var random_range : float
var initial_pitch : float
func _ready() -> void:
	var parent = get_parent()
	if not is_instance_valid(parent):
		return
	initial_pitch = parent.pitch_scale
	parent.connect("finished", self, "randomize_pitch")
	randomize_pitch()

func randomize_pitch() -> void:
	var parent = get_parent()
	if not is_instance_valid(parent):
		return
	var offset = random_range * 0.5
	parent.pitch_scale = initial_pitch + rand_range(-offset , offset)
	
func _get_configuration_warning() -> String:
	var parent = get_parent()
	if parent is AudioStreamPlayer or parent is AudioStreamPlayer2D:
		return ""
	return "parent must be an audio player"
	
