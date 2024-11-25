class_name StarHighlight
extends Node2D

var tween: Tween
func _ready() -> void:
	tween = $Tween

func add_star(star: Node2D):
	add_child(star)
	star.position = Vector2(30, 40);
	tween.interpolate_property(star, "position",
		star.position, Vector2.ZERO, 0.7,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_callback(star, 3.5, "queue_free")
	tween.start()
	
