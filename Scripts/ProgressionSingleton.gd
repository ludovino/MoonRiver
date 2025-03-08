class_name Prog
extends Node

var res : ProgressionRes

func _ready() -> void:
	res = ResourceLoader.load("user://progression.tres") as ProgressionRes
	if res == null:
		res = ProgressionRes.new()
		ResourceSaver.save(res, "user://progression.tres", ResourceSaver.FLAG_CHANGE_PATH)

func save():
	ResourceSaver.save(res, "user://progression.tres", ResourceSaver.FLAG_CHANGE_PATH)

func get_status(level : Level) -> int:
	var status = res.level_status.get(level.progress_key, Level.LOCKED)
	if res.planets_unlocked >= level.progress_level && status == Level.LOCKED:
		set_status(Level.UNLOCKED, level)
		status = Level.UNLOCKED
	return status


func set_status(status : int, level : Level) -> void:
	if not [Level.LOCKED, Level.UNLOCKED, Level.VISITED].has(status):
		push_error("incorrect status pushed: %d" % status)
		return
	res.level_status[level.progress_key] = status
	save()
