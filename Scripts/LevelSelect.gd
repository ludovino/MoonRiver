class_name LevelSelect
extends Node2D

var map : Map
var next_level : Level

signal level_selected

func _ready() -> void:
	map = $Control/Map/Panel/ScreenClip/Map
	for button in map.buttons:
		button.connect("pressed", self, "_select_level", [button.level])

func _after_intro() -> void:
	map.set_focus(next_level)
	_move_ship()

func _focus_launch() -> void:
	$Control/Map/Panel/ScreenClip/Launch.grab_focus()

func _move_ship() -> void:
	map._move_ship_indicator(next_level)

func _on_Launch_pressed() -> void:
	$LaunchSound.play()
	$AnimationPlayer.play("outro")

func _launch_animation_finished() -> void:
	SceneChanger.queue_level(next_level)
	
func _select_level(level : Level) -> void:
	$Control/Map/Panel/ScreenClip/Info/Title.text = level.display_name
	$Control/Map/Panel/ScreenClip/Info/Description.text = level.description
	next_level = level

func _on_Launch_focus_entered() -> void:
	pass
	#var sound = $Control/Modify/Panel/CenterContainer/Shop/ShopBoop
	#sound.pitch_scale = 0.9
	#sound.play()
