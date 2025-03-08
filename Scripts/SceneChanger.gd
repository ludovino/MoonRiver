extends Node

signal scene_queued
signal level_queued
signal level_selected
signal game_finished

func queue_scene_path(path : String) -> void:
	emit_signal("scene_queued", path)

func queue_scene_packed(packed : PackedScene) -> void:
	emit_signal("scene_queued", packed.resource_path)

func queue_level(level : Level) -> void:
	print("TO LEVEL: ", level.display_name)
	emit_signal("level_queued", level)

func level_select() -> void:
	emit_signal("level_selected")

func game_finish(score : int) -> void:
	emit_signal("game_finished", score)
