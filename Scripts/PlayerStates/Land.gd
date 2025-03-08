class_name LandState
extends PlayerState

func enter() -> void:
	player.rod_tip.disable()
	player.anim.play("catch")
	var star = player.lure.remove_star()
	if not is_instance_valid(star):
		return
	star.unhook()
	player.highlight(star)
	player.emit_signal("fight_ended")
	player.emit_signal("star_caught", star)
	player.anim.connect("animation_finished", Callable(self, "animation_ended"))

func animation_ended(name: String) -> void:
	player.anim.disconnect("animation_finished", Callable(self, "animation_ended"))
	player.change_state("Idle")
