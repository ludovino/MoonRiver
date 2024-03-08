extends Node2D

export(Array, PackedScene) var scenes

var index = 0
var current: Node

signal finished


func _ready() -> void:
	_next()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and !event.echo:
		_next()

func _next():
	if index >= scenes.size():
		emit_signal("finished")
		return
	if(current):
		current.queue_free()
	current = scenes[index].instance()
	current.connect("finished", self, "_next")
	add_child(current)
	index += 1
