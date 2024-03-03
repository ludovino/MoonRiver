extends Node2D

func walk(up: bool)-> void:
	if up and $AnimationPlayer.current_animation != "walk-up":
		$AnimationPlayer.play("walk-up")
	elif !up and $AnimationPlayer.current_animation != "walk-down":
		$AnimationPlayer.play("walk-down")

func idle() -> void:
	if $AnimationPlayer.current_animation != "idle":
		$AnimationPlayer.play("idle")
	
func start_cast() -> void:
	$RodTip.disable()
	$AnimationPlayer.play("wind-up")
	$Target.visible = true
	
func release_cast() -> void:
	$RodTip.enable()
	$AnimationPlayer.play("cast")
	$Target.visible = false
	$RodTip.cast()
	
func reel() -> void:
	pass

func cancel() -> void:
	$Target.visible = false
