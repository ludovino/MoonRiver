class_name TensionBar
extends NinePatchRect

var start_height: int
var difference: int

@export var initial_tension_max = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_height = size.y
	difference = start_height - $BarFill.size.y;

func set_tension_max(new_tension_max: float) -> void:
	size.y = floor(start_height * new_tension_max / initial_tension_max)
	$BarFill.size.y = size.y - difference

func set_tension(new_tension_percent: float) -> void:
	var px = new_tension_percent * (size.y - difference)
	$BarFill.size.y = floor(px)

func set_danger(danger_level: float) -> void:
	modulate = lerp(Color.WHITE, Color.RED, danger_level)
