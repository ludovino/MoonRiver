class_name Player
extends Node2D

export var cast_curve_x: Curve
export var cast_curve_y: Curve
export var cast_height: float
export var cast_speed: float

var casting = false
var casting_time = 0
var origin_pos: Vector2

func _ready() -> void:
	$RodTip.disable()
	$Lure.disable()
	$Lure.hide()
	origin_pos = $LureOrigin.position

func _process(delta: float) -> void:
	if casting:
		casting_time += clamp(delta * cast_speed, 0.0, 1.0)
		lure_pos(casting_time, $LureOrigin.position, $Target.position)
		if casting_time >= 1.0:
			casting = false
			$RodTip.set_line($RodTip.slack)
			$Lure.enable()
		
func lure_pos(weight: float, start: Vector2, end: Vector2) -> void:
	var x = lerp(start.x, end.x, cast_curve_x.interpolate_baked(weight))
	var y = lerp(start.y, end.y, weight) - cast_curve_y.interpolate(weight) * cast_height
	$Lure.position = Vector2(x, y)

func walk(up: bool)-> void:
	$RodTip.disable()
	if up and $AnimationPlayer.current_animation != "walk-up":
		$AnimationPlayer.play("walk-up")
	elif !up and $AnimationPlayer.current_animation != "walk-down":
		$AnimationPlayer.play("walk-down")

func idle() -> void:
	$RodTip.disable()
	if $AnimationPlayer.current_animation != "idle":
		$AnimationPlayer.play("idle")
	
func start_cast() -> void:
	$AnimationPlayer.play("wind-up")
	$Lure.position = origin_pos
	$Lure.show()
	$Target.visible = true
	$RodTip.set_line($RodTip.taut)
	$RodTip.enable()
	
func release_cast() -> void:
	casting_time = 0.0
	casting = true
	$RodTip.enable()
	$AnimationPlayer.play("cast")
	$Target.visible = false
	$RodTip.set_line($RodTip.flying)
	
func reel(taut: bool) -> void:
	if $AnimationPlayer.current_animation != "reel":
		$AnimationPlayer.play("reel")
	if(taut):
		$RodTip.set_line($RodTip.taut)

func wait(slack = true) -> void:
	$AnimationPlayer.play("wait")
	if(slack):
		$RodTip.set_line($RodTip.slack)

func land() -> void:
	cancel()
	$AnimationPlayer.play("catch")

func break_line() -> void:
	$Lure.hide()
	$RodTip.set_line($RodTip.flying)
	$AnimationPlayer.play("loss")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Lure, "position", $Lure.position + Vector2(-10, -50), 2)
	
func show_cancel() -> void:
	$RodTip.set_line($RodTip.flying)
	$AnimationPlayer.play("cancel")
	$Target.visible = false
	var start = $Lure.position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(self, "lure_pos", 1.0, 0.0, 1.05, [Vector2(-20, 0), start])

func cancel() -> void:
	casting = false
	$Lure.hide()
	$Lure.disable()
	$Target.visible = false
	$RodTip.disable()
