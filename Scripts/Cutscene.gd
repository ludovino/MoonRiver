extends Node2D

signal finished

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "_on_finished")

func _on_finished(_x):
	emit_signal("finished")
