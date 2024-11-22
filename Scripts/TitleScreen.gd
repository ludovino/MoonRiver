extends Node2D

signal play
signal quit

func _ready() -> void:
	$Title/Menu/Play.grab_focus()

func _on_Play_pressed() -> void:
	emit_signal("play")
	print("pressed play")

func _on_Quit_pressed() -> void:
	emit_signal("quit")
