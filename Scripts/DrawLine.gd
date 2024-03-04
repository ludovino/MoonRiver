extends Node2D

export var taut: Curve
export var slack: Curve
export var flying: Curve
export var line_color: Color

var current_line: Curve 
var previous_line: Curve
export var line_swap_speed: float

var line_weight: float
var to_be_visible: bool = false

export var lure_node_path: NodePath
var lure : Node2D

export var y_displacement: float
export var sample: int
var division: float
var points: Array = []

func _ready() -> void:
	line_weight = 1.0
	current_line = flying
	lure = get_node(lure_node_path).get_node("Offset")
	division = 1.0 / sample
	points.resize(sample)

func _draw() -> void:
	draw_polyline(points, line_color, -1.0)

func _get_line_pos(weight: float) -> Vector2: 
	var pos = lerp(global_position, lure.global_position, weight)
	var current = current_line.interpolate_baked(weight)
	pos.y -= current * y_displacement
	return to_local(pos)
	
func _process(delta: float) -> void:
	line_weight += stepify(delta, 0.1) * line_swap_speed
	line_weight = clamp(line_weight, 0.0, 1.0)
	
	for i in range(0, points.size()):
		points[i] = _get_line_pos(i * division)
	update()
	visible = to_be_visible

func set_line(line: Curve):
	current_line = line



func disable() -> void:
	set_process(false)
	to_be_visible = false
	visible = false

func enable() -> void:
	set_process(true)
	to_be_visible = true
