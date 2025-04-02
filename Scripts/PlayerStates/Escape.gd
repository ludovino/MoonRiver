class_name EscapeState
extends PlayerState

var progress : ProgressionRes
var td_bonus : float
var escape_speed_mod : float
var escape_speed : float
var look_dir : String
func _ready() -> void:
	progress = Progression.res

func enter() -> void:
	escape_speed_mod = player.escape_speed_mod
	player.rod_tip.set_line(player.rod_tip.taut)
	var es_bonus = 1.0 + ((6.0 - progress.escape_level) / 6.0)
	td_bonus = 1.0 + (progress.decay_level / 6.0)
	escape_speed = player.lure.hooked.escape_speed * escape_speed_mod * es_bonus
	var vec =  player.lure.global_position - player.global_position 
	look_dir = player._cardinal_string(-vec)
	player.anim.play("wait-" + look_dir)
	

func tick(delta: float) -> void:
	var intensity = player.lure.hooked.intensity
	var inv = 1.0 - intensity
	if Input.is_action_pressed("action"):
		state_machine.change_state("Fight")
		return
	if Input.is_action_just_pressed("cancel"):
		state_machine.change_state("Loss")
		player.emit_signal("fight_ended")
		return
	player.tension -= player.tension_decay * td_bonus * delta
	var vec =  player.lure.global_position - player.global_position
	var current_dir = player._cardinal_string(-vec)
	if current_dir != look_dir:
		look_dir = current_dir
		player.anim.play("wait-" + look_dir)
	var moved = vec.normalized() * escape_speed * delta * inv
	player.lure.global_position += moved
	player.emit_signal("danger_changed", 0.0)
