class_name WaitState
extends PlayerState

var look_dir : String

func enter() -> void:
	player.lure.enable()
	player.rod_tip.set_line(player.rod_tip.slack)
	var vec = player.global_position - player.lure.global_position
	look_dir = player._cardinal_string(-vec)
	player.anim.play("wait-" + look_dir)
	

func tick(delta: float) -> void:
	var vec = player.global_position - player.lure.global_position
	var current_dir = player._cardinal_string(-vec)
	
	if current_dir != look_dir:
		look_dir = current_dir
		player.anim.play("wait-" + look_dir)
	if Input.is_action_pressed("action"):
		state_machine.change_state("Reel")
		pass
	if Input.is_action_just_pressed("cancel"):
		state_machine.change_state("Cancel")
