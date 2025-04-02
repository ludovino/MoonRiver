class_name IdleState
extends PlayerState

func enter() -> void:
	var dir = player._cardinal_string(player.dir_move)
	player.anim.play("idle-" + dir)
	print("idle entered")
	player.lure.hide()
	player.lure.disable()
	player.target.visible = false
	player.rod_tip.disable()

func tick(delta: float) -> void:
	if not is_zero_approx(player.dir_input.length()):
		state_machine.change_state("Move")
		return
	player.check_act()
