class_name TensionBar
extends NinePatchRect

var start_height: int
var difference: int

export var initial_tension_max = 100.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_height = rect_size.y
	difference = start_height - $BarFill.rect_size.y;

func show() -> void:
	visible = true

func hide() -> void:
	visible = false

func set_tension_max(new_tension_max: float) -> void:
	rect_size.y = floor(start_height * new_tension_max / initial_tension_max)
	$BarFill.rect_size.y = rect_size.y - difference

func set_tension(new_tension_percent: float) -> void:
	var px = new_tension_percent * (rect_size.y - difference)
	$BarFill.rect_size.y = floor(px)

func set_danger(danger_level: float) -> void:
	modulate = lerp(Color.white, Color.red, danger_level)
