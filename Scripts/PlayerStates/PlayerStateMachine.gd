extends Node


var states_dict : Dictionary
var current_state = null

func _ready() -> void:
	for child in get_children():
		states_dict[child.name] = child

func change_state(name : String) -> void:
	print(name)
	var state = states_dict[name]
	if is_instance_valid(current_state):
		current_state.exit()
	current_state = state
	current_state.enter()

func _process(delta: float) -> void:
	current_state.tick(delta)
