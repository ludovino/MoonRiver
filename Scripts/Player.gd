class_name Player
extends CharacterBody2D

@export var cast_curve_x: Curve
@export var cast_curve_y: Curve
@export var cast_height: float
@export var cast_speed: float

@export var walk_speed: float
@export var aim_lerp_curve: float # (float, EASE)
@export var aim_min: float
@export var aim_max: float
@export var aim_speed: float
@export var reel_speed: float
@export var can_cast: bool
@export var max_tension: float
@export var tension_multiplier: float
@export var tension_decay: float
@export var fight_speed_mod: float
@export var escape_speed_mod: float

var casting = false
var wind_up = false
var casting_time = 0
var origin_pos: Vector2
var tension : float = 0: get = get_tension, set = set_tension

@export var lure_path: NodePath
@onready var lure : Lure = $Lure
@onready var target : Node2D = $Target
@onready var lure_origin : Node2D = $LureOrigin
@onready var rod_tip : RodTip = $RodTip
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var icon : Sprite2D = $InteractIcon
@onready var interact_area = $InteractArea
@onready var state_machine = $SM
@onready var rod : Sprite2D = $Body/Rod

var inter_tween : Tween

var dir_input : Vector2 = Vector2.ZERO
var dir_move : Vector2 = Vector2.ZERO
var dir_aim : Vector2 = Vector2.ZERO
var dir_look : Vector2 = Vector2.RIGHT
var can_interact : bool

signal tension_changed
signal danger_changed
signal fight_started
signal fight_ended
signal hook_lost
signal star_caught


var progress : ProgressionRes

func _ready() -> void:
	progress = Progression.res
	
	aim_max += progress.cast_level * 40
	
	icon.visible = false
	rod_tip.disable()
	if lure_path:
		lure.queue_free()
		lure = get_node(lure_path)
	lure.connect("area_entered", Callable(self, "_lure_area_entered"))
	lure.disable()
	lure.hide()
	rod_tip.lure = lure.get_node("Offset")
	origin_pos = lure_origin.global_position
	change_state("Idle")

func change_state(new_state: String):
	state_machine.change_state(new_state)

func _process(delta: float) -> void:
	dir_input = Input.get_vector("left", "right", "up", "down")
	if not can_interact && interact_area.get_overlapping_areas().size() > 0:
		_interact_on()
	elif can_interact && interact_area.get_overlapping_areas().size() == 0:
		_interact_off()
	state_machine.tick(delta)

func _physics_process(delta: float) -> void:
	if not state_machine.current_state.name == "Move": return
	set_velocity(dir_move * walk_speed)
	move_and_slide()

func set_tension(val: float) -> void:
	tension = clamp(val, 0, max_tension + 1.0);
	$Reeler.pitch_scale = 1.0 + (tension / max_tension) * 0.4
	emit_signal("tension_changed", tension)

func get_tension() -> float:
	return tension

func lure_pos(weight: float, start: Vector2, end: Vector2) -> void:
	var x = lerp(start.x, end.x, cast_curve_x.sample_baked(weight))
	var y = lerp(start.y, end.y, weight) - cast_curve_y.sample_baked(weight) * cast_height
	lure.global_position = Vector2(x, y)
	rod_tip._do_line()

func show_cancel() -> void:
	rod_tip.set_line(rod_tip.flying)
	anim.play("cancel")
	target.visible = false
	wind_up = false
	var start = lure.global_position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(Callable(self, "lure_pos").bind(global_position, start), 1.0, 0.0, 1.05)

func check_act() -> bool:
	if can_interact && Input.is_action_just_pressed("action"):
		var inter = get_interactable()
		if inter:
			inter.trigger()
	elif can_cast && Input.is_action_just_pressed("action"):
		change_state("Fishing")
		return true
	return false

func cancel() -> void:
	lure.hide()
	lure.disable()
	target.visible = false
	rod.visible = false
	rod_tip.disable()

func highlight(catch : Node2D) -> void:
	$StarHighlight.add_star(catch)

func _lure_area_entered(body: Node2D) -> void:
	print("body entered: ", body.name)
	print("state: ", state_machine.current_state.name)
	match state_machine.current_state.name:
		"Wait", "Reel":
			if body.is_in_group("star"):
				call_deferred("_hook_star", body as Star)
			elif body.is_in_group("cancel_lure"):
				change_state("Cancel")
			elif body.is_in_group("land"):
				change_state("Cancel")
		"Fight", "Escape":
			if body.is_in_group("star"):
				pass
			elif body.is_in_group("cancel_lure"):
				call_deferred("change_state", "Loss")
			elif body.is_in_group("land"):
				call_deferred("change_state", "Land")

func _hook_star(star : Star) -> void:
	lure.add_star(star)
	star.hook()
	change_state("Fight")
	emit_signal("fight_started")
	set_tension(0)

func _interact_on() -> void:
	can_interact = true
	icon.visible = true
	icon.scale = Vector2.ONE * 1.3
	$InteractNoise.play()
	inter_tween = create_tween()
	inter_tween.set_ease(Tween.EASE_OUT)
	inter_tween.tween_property(icon, "scale", Vector2.ONE, 0.3)
	
func _interact_off() -> void:
	can_interact = false
	icon.visible = false
	if is_instance_valid(inter_tween):
		inter_tween.kill()

func get_interactable() -> Interactable:
	for area in interact_area.get_overlapping_areas():
		if area is Interactable:
			return area
	return null

func _cardinal_string(direction : Vector2) -> String:
	var a_x = abs(direction.x)
	var a_y = abs(direction.y)
	
	if direction.x > a_y:
		return "right"
	elif direction.x < -a_y:
		return "left"
	elif direction.y > 0.0:
		return "down"
	elif direction.y <= -a_x:
		return "up"
	return "right"
