class_name Player
extends KinematicBody2D

export var cast_curve_x: Curve
export var cast_curve_y: Curve
export var cast_height: float
export var cast_speed: float

var casting = false
var wind_up = false
var casting_time = 0
var origin_pos: Vector2

export(NodePath) var lure_path : NodePath
onready var lure : Lure = $Lure
onready var target : Node2D = $Target
onready var lure_origin : Node2D = $LureOrigin
onready var rod_tip : RodTip = $RodTip
onready var anim : AnimationPlayer = $AnimationPlayer
onready var anim_tree : AnimationTree = $AnimationTree

signal lure_area_entered

func _ready() -> void:
	rod_tip.disable()
	if lure_path:
		lure.queue_free()
		lure = get_node(lure_path)
	lure.connect("area_entered", self, "_lure_area_entered")
	lure.disable()
	lure.hide()
	rod_tip.lure = lure.get_node("Offset")
	origin_pos = lure_origin.global_position

func _process(delta: float) -> void:
	if wind_up:
		lure.global_position = lure_origin.global_position
	if casting:
		casting_time += clamp(delta * cast_speed, 0.0, 1.0)
		lure_pos(casting_time, lure_origin.global_position, target.global_position)
		if casting_time >= 1.0:
			casting = false
			rod_tip.set_line(rod_tip.slack)
			lure.enable()
		
func lure_pos(weight: float, start: Vector2, end: Vector2) -> void:
	var x = lerp(start.x, end.x, cast_curve_x.interpolate_baked(weight))
	var y = lerp(start.y, end.y, weight) - cast_curve_y.interpolate(weight) * cast_height
	lure.global_position = Vector2(x, y)

func walk(dir : Vector2)-> void:
	rod_tip.disable()
	var a_x = abs(dir.x)
	var a_y = abs(dir.y)
	
	if is_zero_approx(dir.length()):
		anim.play("idle")
		return
	if dir.x > a_y:
		anim.play("walk-right")
	elif dir.x < -a_y:
		anim.play("walk-left")
	elif dir.y > 0.0:
		anim.play("walk-down")
	elif dir.y <= -a_x:
		anim.play("walk-up")

func idle() -> void:
	rod_tip.disable()
	if anim.current_animation != "idle":
		anim.play("idle")
	
func start_cast() -> void:
	anim_tree.active = false
	wind_up = true
	anim.play("wind-up")
	lure.global_position = lure_origin.global_position
	lure.show()
	target.visible = true
	rod_tip.set_line(rod_tip.taut)
	rod_tip.enable()
	
func release_cast() -> void:
	casting_time = 0.0
	casting = true
	wind_up = false
	rod_tip.enable()
	anim.play("cast")
	target.visible = false
	rod_tip.set_line(rod_tip.flying)
	
func reel(taut: bool) -> void:
	if anim.current_animation != "reel":
		anim.play("reel")
	if(taut):
		rod_tip.set_line(rod_tip.taut)

func wait(slack = true) -> void:
	anim.play("wait")
	if(slack):
		rod_tip.set_line(rod_tip.slack)

func land() -> void:
	cancel()
	anim.play("catch")

func break_line() -> void:
	lure.hide()
	rod_tip.set_line(rod_tip.flying)
	anim.play("loss")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Lure, "global_position", lure.global_position + Vector2(-10, -50), 2)
	
func show_cancel() -> void:
	rod_tip.set_line(rod_tip.flying)
	anim.play("cancel")
	target.visible = false
	wind_up = false
	var start = lure.global_position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(self, "lure_pos", 1.0, 0.0, 1.05, [global_position, start])

func cancel() -> void:
	casting = false
	wind_up = false
	lure.hide()
	lure.disable()
	target.visible = false
	rod_tip.disable()

func highlight(catch : Node2D) -> void:
	$StarHighlight.add_star(catch)

func set_tension(tension: float) -> void:
	var t = clamp(tension, 0.0, 1.0)
	$Reeler.pitch_scale = 1.0 + t * 0.4

func _lure_area_entered(body: Node2D) -> void:
	emit_signal("lure_area_entered", body)
