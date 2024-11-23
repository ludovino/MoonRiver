class_name LevelSelect
extends Node2D

var map : Map
var current_planet : int = 0

signal level_selected

func _ready() -> void:
	map = $Control/Map/Panel/ScreenClip/Map

func _after_intro() -> void:
	$Control/Map/Panel/ScreenClip/Map.set_focus(current_planet)

func _focus_launch() -> void:
	$Control/Map/Panel/ScreenClip/Launch.grab_focus()

func _move_ship() -> void:
	map._move_ship_indicator(current_planet)

func _on_Rock_pressed() -> void:
	current_planet = 0
	_focus_launch()
	_move_ship()
	
func _on_Pebbles_pressed() -> void:
	current_planet = 1
	_focus_launch()
	_move_ship()

func _on_Donut_pressed() -> void:
	current_planet = 2
	_focus_launch()
	_move_ship()

func _on_Moon_pressed() -> void:
	current_planet = 3
	_focus_launch()
	_move_ship()

func _on_Cracked_pressed() -> void:
	current_planet = 4
	_focus_launch()
	_move_ship()

func _on_Blobs_pressed() -> void:
	current_planet = 5
	_focus_launch()
	_move_ship()

func _on_Home_pressed() -> void:
	current_planet = 6
	_focus_launch()
	_move_ship()

func _on_PlanetX_pressed() -> void:
	current_planet = 7
	_focus_launch()
	_move_ship()

func _on_BlackHole_pressed() -> void:
	current_planet = 8
	_focus_launch()
	_move_ship()

func _on_Launch_pressed() -> void:
	$AnimationPlayer.play("outro")

func _launch_animation_finished() -> void:
	emit_signal("level_selected", current_planet)
	
