extends Control

var main_game = preload("res://Main.tscn")
var menu = preload("res://MainMenu.tscn")
var game_over = preload("res://GameOverScene.tscn")
var intro_scene = preload("res://Cutscene.tscn")
var current: Node
var viewport: Viewport
var can_pause = false

func _ready() -> void:
	randomize()
	viewport = $ViewportContainer/Viewport
	_to_main_menu()
	
func _to_main_menu():
	get_tree().paused = false
	$PauseMenu.hide()
	can_pause = false
	var scene = menu.instance()
	swap_scene(scene)
	scene.connect("play", self, "_on_intro")
	scene.connect("quit", self, "_on_quit")

func swap_scene(scene: Node):
	if current:
		viewport.remove_child(current)
		current.queue_free()
	current = scene
	viewport.add_child(scene)

func _on_play():
	$PauseMenu.hide()
	can_pause = true
	var scene = main_game.instance()
	swap_scene(scene)
	scene.connect("game_over", self, "_on_game_over")

func _on_quit():
	get_tree().quit()

func _on_intro():
	$PauseMenu.hide()
	can_pause = true
	var scene = intro_scene.instance()
	swap_scene(scene)
	scene.connect("finished", self, "_on_play")

func _on_game_over(score: int):
	$PauseMenu.hide()
	can_pause = false
	var scene = game_over.instance()
	swap_scene(scene)
	scene.set_score(score)
	scene.connect("replay", self, "_on_play")
	scene.connect("menu", self, "_to_main_menu")

func _input(event: InputEvent) -> void:
	if not can_pause:
		return
	if event.is_action_pressed("pause"):
		if $PauseMenu.visible:
			_on_resume()
		else:
			_on_pause()

func _on_pause():
	get_tree().paused = true
	$PauseMenu.show()
	$PauseMenu/CenterContainer/VBoxContainer/Resume.grab_focus()

func _on_resume():
	get_tree().paused = false
	$PauseMenu.hide()
