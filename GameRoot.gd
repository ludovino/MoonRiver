extends Control

var main_game = preload("res://Main.tscn")
var menu = preload("res://MainMenu.tscn")
var game_over = preload("res://GameOverScene.tscn")
var intro_scene = preload("res://Cutscene.tscn")
var level_select = preload("res://PackedScenes/LevelSelect.tscn")
var progress : Progression

var current_level := 0
var current: Node

var viewport: Viewport
var can_pause = false

func _ready() -> void:
	progress = ResourceLoader.load("user://progression.tres") as Progression
	if progress == null:
		progress = Progression.new()
		ResourceSaver.save("user://progression.tres", progress)
	randomize()
	viewport = $ViewportContainer/Viewport
	_to_main_menu()
	
func _to_main_menu():
	get_tree().paused = false
	$PauseMenu.hide()
	can_pause = false
	var scene = menu.instance()
	swap_scene(scene)
	scene.first_play = progress.first_play
	if progress.first_play:
		scene.connect("play", self, "_on_intro")
	else:
		scene.connect("play", self, "_to_level_select", [0])
	scene.connect("quit", self, "_on_quit")

func swap_scene(scene: Node):
	if current:
		viewport.remove_child(current)
		current.queue_free()
	current = scene
	viewport.add_child(scene)

func _on_play(level : int):
	$PauseMenu.hide()
	can_pause = true
	current_level = level
	var scene = main_game.instance()
	if progress.first_play:
		scene.connect("play", self, "_on_intro")
		progress.first_play = false
	else:
		scene.connect("play", self, "_on_play")
	swap_scene(scene)
	scene.connect("game_over", self, "_to_level_select")

func _on_quit():
	get_tree().quit()

func _on_intro():
	$PauseMenu.hide()
	can_pause = true
	var scene = intro_scene.instance()
	swap_scene(scene)
	scene.connect("finished", self, "_on_play")

func _to_level_select(score: int):
	$PauseMenu.hide()
	progress.units += score
	if score > 0: ResourceSaver.save("user://progression.tres", progress)
	can_pause = false
	var scene = level_select.instance()
	swap_scene(scene)
	scene.current_planet = current_level
	scene._move_ship()
	scene.connect("level_selected", self, "_on_play")

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
