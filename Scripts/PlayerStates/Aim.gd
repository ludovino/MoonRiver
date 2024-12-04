class_name AimState
extends PlayerState

var cast_time := 0.0

func enter() -> void:
	player.anim.play("wind-up")
	player.target.visible = true
	player.target.position.x = player.aim_min
	player.lure.global_position = player.lure_origin.global_position
	player.rod_tip.set_line(player.rod_tip.taut)
	cast_time = 0.0

func tick(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		player.change_state("Idle")
		return
	if Input.is_action_just_pressed("action"):
		player.change_state("Cast")
		return
	player.lure.show()
	player.rod_tip.enable()
	player.lure.global_position = player.lure_origin.global_position
	cast_time += delta * player.aim_speed
	var distance = fmod(cast_time, 2.0)
	if distance > 1.0:
		distance = 2.0 - distance
	distance = ease(distance, 2.5)
	distance = distance * (player.aim_max - player.aim_min) + player.aim_min
	player.target.position.x = distance

func exit() -> void:
	player.target.visible = false
