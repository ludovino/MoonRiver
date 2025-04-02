class_name FishingState
extends PlayerState

@export var sub_state_machine: PlayerStateMachine
@export var entry_state: String
@export var exit_state: String

func enter() -> void:
	player.rod.visible = true
	sub_state_machine.change_state(entry_state)
	sub_state_machine.exited.connect(on_submachine_exited)
	
func tick(delta: float) -> void:
	sub_state_machine.tick(delta)
	
func exit() -> void:
	player.rod.visible = false
	sub_state_machine.change_state("EXIT")

func on_submachine_exited() -> void:
	state_machine.change_state(exit_state)
