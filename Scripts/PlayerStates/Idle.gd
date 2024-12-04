class_name IdleState
extends PlayerState

func enter() -> void:
	player.anim.play("idle")
	print("idle entered")
	player.lure.hide()
	player.lure.disable()
	player.target.visible = false
	player.rod_tip.disable()

func tick(delta: float) -> void:
	if not is_zero_approx(player.dir_input.length()):
		player.change_state("Move")
		return
	player.check_act()
