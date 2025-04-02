class_name PlayerState
extends Node

@onready var player : Player = _get_player()
@onready var state_machine : PlayerStateMachine = get_parent()
func enter() -> void:
	pass

func exit() -> void:
	pass

func tick(delta: float) -> void:
	pass

func _get_player() -> Player:
	var node = self
	while true:
		node = node.get_parent()
		if node is Player:
			return node
		if not is_instance_valid(node):
			break
	return null
	
