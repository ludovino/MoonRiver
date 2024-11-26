class_name DestroyStars
extends Node


export var effect : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area = get_parent() as Area2D
	area.connect("area_entered", self, "_area_entered")
	


func _area_entered(body: Area2D) -> void:
	if body is Star:
		var fx = effect.instance() as Node2D
		add_child(fx)
		fx.global_position = body.global_position
		fx.modulate = body.modulate
		body.queue_free()
	 
