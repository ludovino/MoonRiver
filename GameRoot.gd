extends Control

var menu = preload("res://MainMenu.tscn")
var game_over = preload("res://GameOverScene.tscn")
var intro_scene = preload("res://Cutscene.tscn")
var level_select = preload("res://PackedScenes/LevelSelect.tscn")
var first_level = preload("res://Resources/Levels/Rock.tres")
var progress : ProgressionRes

var current_level : Level
var current: Node

var viewport: SubViewport
var can_pause = false

func _ready() -> void:
	progress = Progression.res
	randomize()
	viewport = $SubViewportContainer/SubViewport
	_to_main_menu()
	SceneChanger.connect("scene_queued", Callable(self, "swap_scene_path"))
	SceneChanger.connect("level_queued", Callable(self, "_change_level"))
	SceneChanger.connect("level_select", Callable(self, "_to_level_select").bind(0))
	SceneChanger.connect("game_finished", Callable(self, "_to_level_select"))

func _change_level(level : Level) -> void:
	progress.current_location = level
	var current_status = Progression.get_status(level)
	if current_status != Level.VISITED and level.intro_scene.is_absolute_path():
		swap_scene_path(level.intro_scene)
	else:
		swap_scene_path(level.scene)
	Progression.set_status(Level.VISITED, level)
	
func _to_main_menu():
	get_tree().paused = false
	$PauseMenu.hide()
	can_pause = false
	var scene = menu.instantiate()
	swap_scene(scene)
	if progress.first_play:
		scene.connect("play", Callable(self, "_on_intro"))
	else:
		scene.connect("play", Callable(self, "_to_level_select").bind(0))
	scene.connect("quit", Callable(self, "_on_quit"))

func swap_scene_path(path: String):
	var packed = load(path) as PackedScene
	swap_scene(packed.instantiate())

func swap_scene(scene: Node):
	if current:
		viewport.remove_child(current)
		current.queue_free()
	current = scene
	viewport.add_child(scene)

func _on_quit():
	get_tree().quit()

func _on_intro():
	$PauseMenu.hide()
	can_pause = true
	var scene = intro_scene.instantiate()
	swap_scene(scene)
	scene.connect("finished", Callable(self, "_intro_finished"))

func _intro_finished() -> void:
	_change_level(first_level)
	
func _to_level_select(score: int):
	$PauseMenu.hide()
	progress.units += score
	progress.first_play = false
	Progression.save()
	can_pause = false
	var scene = level_select.instantiate()
	swap_scene(scene)
	scene._move_ship()
	scene.connect("level_selected", Callable(self, "_on_play"))

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
