class_name LossState
extends PlayerState

func enter() -> void:
	player.lure.hide()
	
	player.emit_signal("fight_ended")
	var star = player.lure.remove_star()
	star.queue_free()
	player.rod_tip.set_line(player.rod_tip.flying)
	var vec = player.global_position - player.lure.global_position
	var look_dir = player._cardinal_string(-
	vec)
	player.anim.play("cancel-" + look_dir) #directionize
	player.anim.queue("loss")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(player.lure, "global_position", player.lure.global_position + Vector2(-10, -50), 2)
	player.anim.connect("animation_finished", Callable(self, "animation_ended"))

func animation_ended(name: String) -> void:
	if name != "loss":
		return
	player.anim.disconnect("animation_finished", Callable(self, "animation_ended"))
	player.emit_signal("hook_lost")
	state_machine.exit()
