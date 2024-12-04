extends Node2D


export var level_resource : Resource
var level : Level
signal exit_clicked

func _ready() -> void:
	level = level_resource as Level
	level.set_status(level.VISITED)
	$Modify/Shop/Exit.connect("pressed", self, "_exit")

func _exit() -> void:
	SceneChanger.level_select()
