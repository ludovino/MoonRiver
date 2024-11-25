class_name Lure
extends Area2D

var hooked: Star
var noise = OpenSimplexNoise.new()
export var frequency = 64.0
export var base_magnitude = 50.0
var time = 0.0

func _ready() -> void:
	add_to_group("lure")
	noise.seed = randi()
	noise.period = 10

func _process(delta: float) -> void:
	time += delta * frequency
	if hooked:
		var x = noise.get_noise_2d(time, 0)
		var y = noise.get_noise_2d(0, time)
		$Offset.position = Vector2(x, y) * hooked.intensity * hooked.magnitude * base_magnitude

func hide() -> void:
	$Sprite.visible = false

func show() -> void:
	$Sprite.visible = true

func enable() -> void:
	monitoring = true
	monitorable = true

func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func add_star(star: Star):
	hide()
	hooked = star
	hooked.get_parent().remove_child(hooked)
	$Offset.add_child(hooked)
	hooked.position = Vector2.ZERO

func remove_star() -> Star:
	$Offset.remove_child(hooked)
	$Offset.position = Vector2.ZERO
	var star = hooked
	hooked = null
	return star
