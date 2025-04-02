class_name CastState
extends PlayerState

var casting_time := 0.0

func enter() -> void:
	player.rod_tip.set_line(player.rod_tip.flying)
	player.lure.global_position = player.lure_origin.global_position
	var current_dir = player._cardinal_string(player.dir_aim)
	player.anim.play("cast-" + current_dir)
	casting_time = 0.0
	player.lure.disable()
	

func tick(delta: float) -> void:
	casting_time += clamp(delta * player.cast_speed, 0.0, 1.0)
	player.lure_pos(casting_time, player.lure_origin.global_position, player.target.global_position)
	if casting_time >= 1.0:
		state_machine.change_state("Wait")
		pass

func exit() -> void:
	player.tension = 0.0
