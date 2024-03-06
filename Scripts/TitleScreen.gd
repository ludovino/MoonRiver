extends Node2D

signal play

func _ready() -> void:
	$Play.grab_focus()

func _on_Play_pressed() -> void:
	emit_signal("play")
	print("pressed play")
