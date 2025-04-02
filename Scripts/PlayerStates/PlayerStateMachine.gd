class_name PlayerStateMachine
extends Node

var states_dict : Dictionary
var current_state = null

signal exited

func _ready() -> void:
	for child in get_children():
		states_dict[child.name] = child

func change_state(name : String) -> void:
	var state = null if name == "EXIT" else states_dict[name]
	if is_instance_valid(current_state):
		current_state.exit()
	current_state = state
	if is_instance_valid(current_state):
		current_state.enter()

func tick(delta: float) -> void:
	current_state.tick(delta)

func exit() -> void:
	exited.emit()
