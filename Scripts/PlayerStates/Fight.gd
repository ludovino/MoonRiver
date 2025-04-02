class_name FightState
extends PlayerState

var progress : ProgressionRes
var rs_bonus : float
var reel_speed_mod : float
var look_dir : String
func _ready() -> void:
	progress = Progression.res

func enter() -> void:
	player.rod_tip.set_line(player.rod_tip.taut)
	rs_bonus = 1.0 + (progress.pull_level / 6.0)
	rs_bonus *= player.fight_speed_mod
	reel_speed_mod = player.lure.hooked.reel_speed_mod * rs_bonus
	var vec = player.global_position - player.lure.global_position
	look_dir = player._cardinal_string(-vec)
	player.anim.play("reel-" + look_dir)
	

func tick(delta: float) -> void:
	var intensity = player.lure.hooked.intensity
	var inv = 1.0 - intensity
	if not Input.is_action_pressed("action"):
		player.change_state("Escape")
	if Input.is_action_just_pressed("cancel"):
		player.change_state("Loss")
		player.emit_signal("fight_ended")
		return
	var tf_bonus = (1.0 - (progress.escape_level / 8.0)) * player.tension_multiplier
	player.tension += intensity * delta * tf_bonus
	if player.tension > player.max_tension:
		player.change_state("Loss")
		return
	var vec = player.global_position - player.lure.global_position
	var current_dir = player._cardinal_string(-vec)
	
	if current_dir != look_dir:
		look_dir = current_dir
		player.anim.play("reel-" + look_dir)
	
	var moved = vec.normalized() * player.reel_speed * delta * inv * reel_speed_mod
	player.lure.global_position += moved
	
	player.emit_signal("danger_changed", intensity)
