class_name PixelSprite
extends Sprite2D


func _process(delta: float) -> void:
	offset.x = round(global_position.x) - global_position.x
	offset.y = round(global_position.y) - global_position.y
