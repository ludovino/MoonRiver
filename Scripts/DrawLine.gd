extends Node2D

export var taut: Curve
export var slack: Curve
export var flying: Curve
export var line_color: Color

var current_line: Curve 
var previous_line: Curve

var line_weight: float
var line_swap_speed: float

export var lure_node_path: NodePath
var lure : Node2D

export var y_displacement: float
export var sample: int
var division: float
var points: Array = []

func _ready() -> void:
	line_weight = 1.0
	current_line = flying
	previous_line = flying
	lure = get_node(lure_node_path)
	division = 1.0 / sample
	points.resize(sample)

func _draw() -> void:
	draw_polyline(points, line_color, -1.0)

func _get_line_pos(weight: float) -> Vector2: 
	var pos = lerp(global_position, lure.global_position, weight)
	var current = current_line.interpolate_baked(weight)
	var prev = previous_line.interpolate_baked(weight)
	var weighted = lerp(prev, current, line_weight)
	pos.y -= weighted * y_displacement
	return to_local(pos)
	
func _process(delta: float) -> void:
	
	line_weight += delta * line_swap_speed
	line_weight = clamp(line_weight, 0.0, 1.0)
	
	for i in range(0, points.size()):
		points[i] = _get_line_pos(i * division)
	
	update()

func cast():
	line_weight = 0
	line_swap_speed = 4
	previous_line = flying
	current_line = slack

func settle():
	line_weight = 0
	line_swap_speed = 0.3
	previous_line = current_line
	current_line = slack

func reel():
	line_weight = 0
	line_swap_speed = 6.0
	previous_line = current_line
	current_line = taut

func disable() -> void:
	set_process(false)
	visible = false

func enable() -> void:
	set_process(true)
	visible = true
