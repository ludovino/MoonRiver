@tool
class_name River
extends Node2D

@export var star_scene: PackedScene
@export var star_reources = [] # (Array, Resource)
@export var prog_res: Resource
var progress : ProgressionRes

@export var width: float
@export var height: float

@export var initial_height: float
@export var initial_stars: float

@export var spawn_time: float
var current_time: float = 0.0
@export var speed: float

@export var color : Color

const bounds = Rect2(-100, -100, 640 + 400, 360 + 400)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if prog_res == null:
		progress = Progression.res
	else:
		progress = prog_res as ProgressionRes
	if initial_stars == 0: return
	for _i in range(0, initial_stars):
		spawn_star(width, initial_height, -200)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return
	current_time += delta
	if current_time > spawn_time:
		current_time = 0.0
		spawn_star(width, height, 0)
	for star in get_children():
		star.position += Vector2.UP * speed * delta
		if not bounds.has_point(star.global_position):
			star.queue_free()

func _draw() -> void:
	if Engine.is_editor_hint():
		var start = Vector2.LEFT * width / 2.0
		var end = Vector2.RIGHT * width / 2.0
		draw_line(start, end, Color.WHITE, 2.0)
		draw_rect(Rect2(Vector2(-width/2.0, 0), Vector2(width, -400)), color, false)

func spawn_star(w: float, h: float, y_offset: float):
	var star = star_scene.instantiate()
	var data = star_reources[randi() % star_reources.size()] as StarData
	add_child(star)
	if star is Star:
		star.setup(color, progress.catch_level, data)
		star.add_to_group("star")
	star.global_rotation = 0.0
	star.position = Vector2(randf_range(-0.5 * w, 0.5 * w), randf_range(-0.5 * h, 0.5 * h) + y_offset)
