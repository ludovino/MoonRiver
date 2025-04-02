class_name MoveState
extends PlayerState

func enter() -> void:
	player.anim.play("idle")

func tick(delta: float) -> void:
	var dir = player.dir_input
	player.rod_tip.disable()
	
	if is_zero_approx(dir.length()):
		state_machine.change_state("Idle")
		return
	if player.check_act():
		return
	player.anim.play("walk-" + player._cardinal_string(dir))
	player.dir_move = dir

func exit() -> void:
	player.dir_move = Vector2.ZERO
	player.position = Vector2(round(player.position.x), round(player.position.y))
