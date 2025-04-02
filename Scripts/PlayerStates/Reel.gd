class_name ReelState
extends PlayerState

var look_dir : String

func enter() -> void:
	player.lure.enable()
	player.rod_tip.set_line(player.rod_tip.taut)
	var vec = player.global_position - player.lure.global_position
	look_dir = player._cardinal_string(-vec)
	player.anim.play("reel-" + look_dir)
	

func tick(delta: float) -> void:
	if Input.is_action_just_released("action"):
		state_machine.change_state("Wait")
		pass
	if Input.is_action_just_pressed("cancel"):
		state_machine.change_state("Cancel")
	var vec = player.global_position - player.lure.global_position
	var current_dir = player._cardinal_string(-vec)
	
	if current_dir != look_dir:
		look_dir = current_dir
		player.anim.play("reel-" + look_dir)
	var moved = vec.normalized() * delta * player.reel_speed
	player.lure.global_position += moved
