class_name MoveState
extends PlayerState

func enter() -> void:
	player.anim.play("idle")

func tick(delta: float) -> void:
	var dir = player.dir_input
	player.rod_tip.disable()
	var a_x = abs(dir.x)
	var a_y = abs(dir.y)
	
	if is_zero_approx(dir.length()):
		player.change_state("Idle")
		return
	if player.check_act():
		return
	
	if dir.x > a_y:
		player.anim.play("walk-right")
	elif dir.x < -a_y:
		player.anim.play("walk-left")
	elif dir.y > 0.0:
		player.anim.play("walk-down")
	elif dir.y <= -a_x:
		player.anim.play("walk-up")
	player.dir_move = dir

func exit() -> void:
	player.dir_move = Vector2.ZERO
	player.position = Vector2(round(player.position.x), round(player.position.y))
