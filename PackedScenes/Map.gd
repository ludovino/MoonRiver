class_name Map
extends Control

var progress : Progression
var buttons : Array = []
var lines : Array = []

func _ready() -> void:
	progress = ResourceLoader.load("user://progression.tres") as Progression
	if progress == null:
		progress = Progression.new()
		ResourceSaver.save("user://progression.tres", progress)
	for child in get_children():
		if child is PlanetButton:
			buttons.append(child)
			child.connect("focus_entered", self, "_focus_beep")
			child.connect("pressed", self, "_select_beep")
		if child is Line2D:
			lines.append(child)
	if progress.planets_unlocked >= 7:
		rect_scale = Vector2.ONE * 0.5
		for i in range(7):
			buttons[i].rect_scale = Vector2.ONE * 2
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

func _tween_scale(tween : SceneTreeTween) -> SceneTreeTween:
	tween.tween_property(self, "rect_scale", Vector2.ONE * 0.5, 0.6)
	for i in range(7):
		tween.parallel().tween_property(buttons[i], "rect_scale", Vector2.ONE * 2, 0.6)
	tween.tween_property($MapShip, "scale", Vector2.ONE * 2, 0.6)
	return tween

func _move_ship_indicator(planet : Level) -> void:
	for button in buttons:
		if button.level != planet:
			continue
		var target_pos = button.rect_global_position + button.rect_pivot_offset * 0.6
		$MapShip.global_position = target_pos
