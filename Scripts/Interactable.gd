class_name Interactable
extends Area2D

signal triggered

func _ready() -> void:
	monitoring = false
	add_to_group("interactable")

func trigger() -> void:
	emit_signal("triggered")
