class_name StarHighlight
extends Node2D


func add_star(star: Node2D):
	var tween = create_tween()
	add_child(star)
	star.position = Vector2(30, 40);
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(star, "position", Vector2.ZERO, 0.7)
	tween.tween_interval(3.5)
	tween.tween_callback(star.queue_free)
	
