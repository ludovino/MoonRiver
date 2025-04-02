class_name ChargeState
extends PlayerState

var cast_time := 0.0
func enter() -> void:
	var current_dir = player._cardinal_string(player.dir_aim)
	player.anim.play("wind-up-" + current_dir)
	player.target.visible = true
	player.target.position = player.dir_aim * player.aim_min
	player.lure.global_position = player.lure_origin.global_position
	player.rod_tip.set_line(player.rod_tip.taut)
	cast_time = 0.0

func tick(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		state_machine.exit()
		return
	if Input.is_action_just_pressed("action"):
		state_machine.change_state("Cast")
		return
	player.lure.show()
	player.rod_tip.enable()
	player.lure.global_position = player.lure_origin.global_position
	cast_time += delta * player.aim_speed
	var distance = fmod(cast_time, 2.0)
	if distance > 1.0:
		distance = 2.0 - distance
	distance = ease(distance, 2.5)
	distance = distance * (player.aim_max - player.aim_min) + player.aim_min
	player.target.position = player.dir_aim * distance

func exit() -> void:
	player.target.visible = false
