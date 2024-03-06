extends Control

var main_game = preload("res://Main.tscn")
var menu = preload("res://MainMenu.tscn")
var game_over = preload("res://GameOverScene.tscn")

var current: Node
var viewport: Viewport

func _ready() -> void:
	randomize()
	viewport = $ViewportContainer/Viewport
	_to_main_menu()
	
func _to_main_menu():
	var scene = menu.instance()
	swap_scene(scene)
	scene.connect("play", self, "_on_play")

func swap_scene(scene: Node):
	if current:
		viewport.remove_child(current)
		current.queue_free()
	current = scene
	viewport.add_child(scene)

func _on_play():
	var scene = main_game.instance()
	swap_scene(scene)
	scene.connect("game_over", self, "_on_game_over")

func _on_game_over(score: int):
	var scene = game_over.instance()
	swap_scene(scene)
	scene.set_score(score)
	scene.connect("replay", self, "_on_play")
	scene.connect("menu", self, "_to_main_menu")
