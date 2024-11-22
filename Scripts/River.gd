tool
class_name River
extends Node2D

export(Array, PackedScene) var stars = []

export var width: float
export var height: float

export var initial_height: float
export var initial_stars: float

export var spawn_time: float
var current_time: float = 0.0
export var speed: float

func _ready() -> void:
	if initial_stars == 0: return
	for _i in range(0, initial_stars):
		spawn_star(width, initial_height, -200)

func _process(delta: float) -> void:
	if Engine.editor_hint:
		update()
		return
	current_time += delta
	if current_time > spawn_time:
		current_time = 0.0
		spawn_star(width, height, 0)
	for star in get_children():
		star.position += Vector2.UP * speed * delta
		if star.global_position.y < -10:
			star.queue_free()

func _draw() -> void:
		var start = global_position + Vector2.LEFT * width / 2.0
		var end = global_position + Vector2.RIGHT * width / 2.0
		draw_line(start, end, Color.white, 2.0)

func spawn_star(w: float, h: float, y_offset: float):
	var star = stars[randi() % stars.size()].instance()
	add_child(star)
	star.position = Vector2(rand_range(-0.5 * w, 0.5 * w), rand_range(-0.5 * h, 0.5 * h) + y_offset)
