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
		$Lure.position = lure_pos(casting_time)
		if casting_time >= 1.0:
			casting = false
			$RodTip.set_line($RodTip.slack)
			$Lure.enable()
		
func lure_pos(weight: float) -> Vector2:
	var org = $LureOrigin.position
	var tar = $Target.position
	var x = lerp(org.x, tar.x, cast_curve_x.interpolate_baked(weight))
	var y = lerp(org.y, tar.y, weight) - cast_curve_y.interpolate(weight) * cast_height
	return Vector2(x, y)

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
	$AnimationPlayer.play("reel")
	if(taut):
		$RodTip.set_line($RodTip.taut)

func wait(slack = true) -> void:
	$AnimationPlayer.play("wait")
	if(slack):
		$RodTip.set_line($RodTip.slack)

func cancel() -> void:
	casting = false
	$Lure.hide()
	$Lure.disable()
	$Target.visible = false
	$RodTip.disable()
