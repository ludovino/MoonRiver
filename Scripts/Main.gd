extends Node2D

enum state { move, cast, wait, fight, lose, land }

var current_state = state.move

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	match current_state:
		state.move:
			_process_move()
		state.cast:
			_process_cast()
		state.wait:
			_process_wait()
		state.fight:
			_process_fight()
		state.lose:
			_process_lose()
		state.land:
			_process_land()
		
		
func _process_move():
	pass

func _process_cast():
	pass

func _process_wait():
	pass

func _process_fight():
	pass

func _process_lose():
	pass

func _process_land():
	pass
