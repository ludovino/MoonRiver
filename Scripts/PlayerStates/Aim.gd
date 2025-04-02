class_name AimState
extends PlayerState

var look_dir : String

func enter() -> void:
	player.target.global_position = get_viewport().get_mouse_position()
	player.dir_aim = player.target.position.normalized()
	look_dir = player._cardinal_string(player.dir_aim)
	player.anim.play("wind-up-" + look_dir)
	player.target.visible = true
	player.target.global_position = player.get_global_mouse_position()
	player.lure.global_position = player.lure_origin.global_position
	player.rod_tip.set_line(player.rod_tip.taut)

func tick(delta: float) -> void:
	player.target.global_position = player.get_global_mouse_position()
	
	if Input.is_action_just_pressed("cancel"):
		state_machine.exit()
		return
	if Input.is_action_just_pressed("action"):
		state_machine.change_state("Charge")
		return
		
	player.dir_aim = player.target.position.normalized()
	var current_dir = player._cardinal_string(player.dir_aim)
	if current_dir != look_dir:
		look_dir = current_dir
		player.anim.play("wind-up-" + look_dir)
	
	player.lure.show()
	player.rod_tip.enable()
	player.lure.global_position = player.lure_origin.global_position

func exit() -> void:
	player.target.visible = false
