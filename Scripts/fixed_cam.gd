extends Camera2D

@export var height : int
@export var width : int
@export var player : Player

func _process(delta: float) -> void:
	var to_player = player.global_position
	var pos_x = snappedi(to_player.x - width/2, width)
	var pos_y = snappedi(to_player.y - height/2, height)
	global_position = Vector2(pos_x, pos_y)
