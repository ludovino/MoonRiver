class_name ReelState
extends PlayerState

func enter() -> void:
	player.lure.enable()
	player.rod_tip.set_line(player.rod_tip.taut)
	player.anim.play("reel")
	

func tick(delta: float) -> void:
	if Input.is_action_just_released("action"):
		player.change_state("Wait")
		pass
	if Input.is_action_just_pressed("cancel"):
		player.change_state("Cancel")
	var vec = player.global_position - player.lure.global_position
	var moved = vec.normalized() * delta * player.reel_speed
	player.lure.global_position += moved
