class_name PlanetButton
extends TextureButton

export var level_resource : Resource
var level : Level
var progression : Progression
var unlocked_tex : Texture = preload("res://Sprites/Map/mystery.png")
var unlocked_highlighted_tex: Texture = preload("res://Sprites/Map/mysteryHL.png")

func _ready() -> void:
	level = level_resource as Level
	var status = level.get_status()
	var name = level.display_name
	match status:
		level.LOCKED:
			visible = false
			return
		level.UNLOCKED:
			name = "???"
			texture_normal = unlocked_tex
			texture_focused = unlocked_highlighted_tex
			texture_hover = unlocked_highlighted_tex
		level.VISITED:
			texture_normal = level.ls_texture
			texture_focused = level.ls_highlight
			texture_hover = level.ls_highlight

	var label = Label.new()
	add_child(label)
	label.text = name
	label.rect_position = Vector2(5, 50)

