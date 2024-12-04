class_name Level
extends Resource

export var display_name : String
export var progress_key : String
export var progress_level : int
export(String, FILE, "*.tscn") var scene
export(String, FILE, "*.tscn") var intro_scene
export(String, MULTILINE) var description : String
export(Array, Resource) var stars
export var ls_texture : Texture
export var ls_highlight : Texture
export var pausable : bool

enum { LOCKED, UNLOCKED, VISITED }

var progression = preload("user://progression.tres")

func get_status() -> int:
	var status = progression.level_status.get(progress_key, LOCKED)
	if progression.planets_unlocked > progress_level && status == LOCKED:
		set_status(UNLOCKED)
		status = UNLOCKED
	return status

func set_status(status : int) -> void:
	if not [LOCKED, UNLOCKED, VISITED].has(status):
		push_error("incorrect status pushed: %d" % status)
		return
	progression.level_status[progress_key] = status
	ResourceSaver.save("user://progression.tres", progression)
