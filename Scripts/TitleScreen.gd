extends Node2D

func _ready() -> void:
	var game_scene = load("res://Main")

func _on_Play_pressed() -> void:
	emit_signal("play")


# TODO: make "root" scene with music (settings?)
