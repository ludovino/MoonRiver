class_name CancelState
extends PlayerState

func enter() -> void:
	player.rod_tip.set_line(player.rod_tip.flying)
	player.anim.play("cancel")
	var start = player.lure.global_position
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(Callable(player, "lure_pos").bind(player.global_position, start), 1.0, 0.0, 1.05)
	tween.connect("finished", Callable(self, "animation_ended"))

func animation_ended() -> void:
	player.change_state("Idle")
