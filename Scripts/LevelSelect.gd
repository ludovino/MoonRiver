class_name LevelSelect
extends Node2D

var map : Map
var next_level : Level

signal level_selected

func _ready() -> void:
	var progress = Progression.res
	_select_level(progress.current_location as Level)
	map = $Control/Map/Panel/ScreenClip/Map
	for button in map.buttons:
		button.connect("pressed", self, "_select_level", [button.level])

func _after_intro() -> void:
	map.set_focus(next_level)
	_move_ship()

func _focus_launch() -> void:
	$Control/Map/Panel/Info/Launch.grab_focus()

func _move_ship() -> void:
	map._move_ship_indicator(next_level)

func _on_Launch_pressed() -> void:
	$LaunchSound.play()
	$AnimationPlayer.play("outro")

func _launch_animation_finished() -> void:
	SceneChanger.queue_level(next_level)
	
func _select_level(level : Level) -> void:
	if not is_instance_valid(level):
		$Control/Map/Panel/Info/Title.text = "Lost"
		$Control/Map/Panel/Info/Description.text = "scanning for nearby planets..."
		return
	if Progression.get_status(level) != Level.VISITED:
		$Control/Map/Panel/Info/Title.text = "???"
		$Control/Map/Panel/Info/Description.text = "A new object to investiage"
	else:
		$Control/Map/Panel/Info/Title.text = level.display_name
		$Control/Map/Panel/Info/Description.text = level.description
	next_level = level

func _on_Launch_focus_entered() -> void:
	pass
	#var sound = $Control/Modify/Panel/CenterContainer/Shop/ShopBoop
	#sound.pitch_scale = 0.9
	#sound.play()
