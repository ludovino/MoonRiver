extends Area2D

var hooked: Star

func hide() -> void:
	$Sprite.visible = false

func show() -> void:
	$Sprite.visible = true

func enable() -> void:
	monitoring = true
	monitorable = true

func disable() -> void:
	monitoring = false
	monitorable = false

func add_star(star: Star):
	add_child(star)
	hooked = star
	hooked.position = Vector2.ZERO

func remove_star() -> Star:
	remove_child(hooked)
	return hooked
