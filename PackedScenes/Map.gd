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

func _update_map() -> void:
	var planets_unlocked = progress.planets_unlocked
	for i in range(buttons.size()):
		buttons[i].disabled = i > planets_unlocked
	for i in range(lines.size()):
		lines[i].visible = i < planets_unlocked

func _tween_scale(tween : SceneTreeTween) -> SceneTreeTween:
	tween.tween_property(self, "rect_scale", Vector2.ONE * 0.5, 0.6)
	for i in range(7):
		tween.parallel()
		tween.tween_property(buttons[i], "rect_scale", Vector2.ONE * 2, 0.6)
	tween.parallel()
	tween.tween_property($MapShip, "scale", Vector2.ONE * 2, 0.6)
	return tween

func _move_ship_indicator(idx : int) -> void:
	var button = buttons[idx] as TextureButton
	var target_pos = button.rect_global_position + button.rect_pivot_offset * 0.6
	$MapShip.global_position = target_pos

func _on_Shop_unlock_purchased() -> void:
	#animate purchase
	_update_map()
	var updated = buttons[progress.planets_unlocked]
	var tween = create_tween()
	var mult = 1.0 if progress.planets_unlocked < 7 else 2.0
	if progress.planets_unlocked == 7:
		tween = _tween_scale(tween)
	tween.tween_property(updated, "rect_scale", Vector2.ONE * 1.3 * mult, 0.1)
	tween.tween_property(updated, "rect_scale", Vector2.ONE * 1 * mult, 0.4)
