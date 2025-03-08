class_name Map
extends Control

var progress : ProgressionRes
var buttons : Array = []
var lines : Array = []

func _ready() -> void:
	progress = Progression.res
	for child in get_children():
		if child is PlanetButton:
			buttons.append(child)
			child.connect("focus_entered", Callable(self, "_focus_beep"))
			child.connect("pressed", Callable(self, "_select_beep"))
		if child is Line2D:
			lines.append(child)
	if progress.planets_unlocked >= 7:
		scale = Vector2.ONE * 0.5
		for i in range(7):
			buttons[i].scale = Vector2.ONE * 2
		$MapShip.scale = Vector2.ONE * 2

func set_focus(planet : Level) -> void:
	for button in buttons:
		if button.level != planet:
			continue
		print(buttons)
		button.grab_focus()


func _focus_beep() -> void:
	$Change.play()

func _select_beep() -> void:
	$Select.play()

func _tween_scale(tween : Tween) -> Tween:
	tween.tween_property(self, "scale", Vector2.ONE * 0.5, 0.6)
	for i in range(7):
		tween.parallel().tween_property(buttons[i], "scale", Vector2.ONE * 2, 0.6)
	tween.tween_property($MapShip, "scale", Vector2.ONE * 2, 0.6)
	return tween

func _move_ship_indicator(planet : Level) -> void:
	for button in buttons:
		if button.level != planet:
			continue
		var target_pos = button.global_position + button.pivot_offset * 0.6
		$MapShip.global_position = target_pos
