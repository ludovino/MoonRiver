@tool
class_name AudioRandomize
extends Node

@export var random_range : float # (float, 0.0, 0.5, 0.01)
var initial_pitch : float
func _ready() -> void:
	var parent = get_parent()
	if not is_instance_valid(parent):
		return
	initial_pitch = parent.pitch_scale
	parent.connect("finished", Callable(self, "randomize_pitch"))
	randomize_pitch()

func randomize_pitch() -> void:
	var parent = get_parent()
	if not is_instance_valid(parent):
		return
	var offset = random_range * 0.5
	parent.pitch_scale = initial_pitch + randf_range(-offset , offset)
	print("offset: ", offset)
	print("pitch scale: ", parent.pitch_scale)
	
func _get_configuration_warnings() -> PackedStringArray:
	var parent = get_parent()
	if parent is AudioStreamPlayer or parent is AudioStreamPlayer2D:
		return PackedStringArray([])
	return PackedStringArray(["parent must be an audio player"])
	
