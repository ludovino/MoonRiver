class_name WaitState
extends PlayerState

func enter() -> void:
	player.lure.enable()
	player.rod_tip.set_line(player.rod_tip.slack)
	player.anim.play("wait")
	

func tick(delta: float) -> void:
	if Input.is_action_pressed("action"):
		player.change_state("Reel")
		pass
	if Input.is_action_just_pressed("cancel"):
		player.change_state("Cancel")
