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
		if child is TextureButton:
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
	_update_map()

func set_focus(planet : int) -> void:
	var button = buttons[planet] as TextureButton
	print(buttons)
	button.grab_focus()


func _focus_beep() -> void:
	$Change.play()

func _select_beep() -> void:
	$Select.play()

func _update_map() -> void:
	var planets_unlocked = progress.planets_unlocked
	for i in range(buttons.size()):
		var button = buttons[i] as TextureButton
		var locked = i > planets_unlocked
		button.disabled = locked
		button.focus_mode = FOCUS_NONE if locked else FOCUS_ALL
	for i in range(lines.size()):
		lines[i].visible = i < planets_unlocked

func _tween_scale(tween : SceneTreeTween) -> SceneTreeTween:
	tween.tween_property(self, "rect_scale", Vector2.ONE * 0.5, 0.6)
	for i in range(7):
		tween.parallel().tween_property(buttons[i], "rect_scale", Vector2.ONE * 2, 0.6)
	tween.tween_property($MapShip, "scale", Vector2.ONE * 2, 0.6)
	return tween

func _move_ship_indicator(idx : int) -> void:
	var button = buttons[idx] as TextureButton
	var target_pos = button.rect_global_position + button.rect_pivot_offset * 0.6
	$MapShip.global_position = target_pos

func _on_Shop_unlock_purchased() -> void:
	_update_map()
	var updated = buttons[progress.planets_unlocked]
	var tween = create_tween()
	var mult = 1.0 if progress.planets_unlocked < 7 else 2.0
	if progress.planets_unlocked == 7:
		tween = _tween_scale(tween)
	tween.tween_property(updated, "rect_scale", Vector2.ONE * 1.3 * mult, 0.1)
	tween.tween_property(updated, "rect_scale", Vector2.ONE * 1 * mult, 0.4)
