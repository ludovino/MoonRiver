extends Node

enum state { move, cast, wait, fight, lose, land }
enum Layers { DEFAULT = 0, STARS = 1, LURE = 2, EFFECTORS = 4 }
var progress : ProgressionRes
@export var prog_res: Resource

@export var player_path: NodePath
@export var ship_path: NodePath

@export var player_speed: float

@export var aim_min: float
@export var aim_max: float
@export var aim_speed: float

@export var reel_speed: float
@export var escape_speed_mod: float
@export var fight_speed_mod: float
var cast_time: float

@export var max_tension: float
@export var tension_decay: float
@export var tension_multiplier: float
@export var score_multiplier: int

@export var hooks: int

signal score_change
signal tension_change
signal game_over

var tension: float
var score:int = 0
var current_state = null

var lure: Lure
var reels_display: ReelsDisplay
var timer_display: Label
var game_timer: Timer
var player: Player
var target: Node2D
var lure_origin: Node2D
var tension_bar: TensionBar
var bar_fill: Node2D
var star_highlight: StarHighlight
var sfx: AudioStreamPlayer
var fade: PackedScene
var ship: Ship
var alert := false

func _ready() -> void:
	fade = load("res://PackedScenes/FadeOut.tscn")
	if prog_res == null:
		progress = Progression.res
	else:
		progress = prog_res as ProgressionRes
	game_timer = $GameTime
	game_timer.connect("timeout", Callable(self, "_out_of_time"))
	timer_display = $CanvasLayer/SideBar/VBoxContainer/Timer
	player = $Player if is_instance_valid($Player) else get_node(player_path)
	ship = $Ship if is_instance_valid($Ship) else get_node(ship_path)
	ship.connect("player_boarded", Callable(self, "_launch"))
	player.connect("tension_changed", Callable(self, "_on_tension_changed"))
	player.connect("fight_started", Callable(self, "_on_fight_started"))
	player.connect("fight_ended", Callable(self, "_on_fight_ended"))
	player.connect("hook_lost", Callable(self, "_on_hook_lost"))
	player.connect("star_caught", Callable(self, "_on_star_caught"))
	player.connect("danger_changed", Callable(self, "_on_danger_changed"))
	player.tension_multiplier = tension_multiplier
	player.tension_decay = tension_decay
	player.escape_speed_mod = escape_speed_mod
	player.fight_speed_mod = fight_speed_mod
	tension_bar = $CanvasLayer/TensionBar
	reels_display = $CanvasLayer/SideBar/VBoxContainer/Center/Reels
	sfx = $SfxPlayer
	$Timer.start(1.5)
	game_timer.start(121.5 + progress.oxygen_level * 30)
	hooks = 3 + progress.reels_level
	reels_display.adjust(hooks)
	tension_bar.hide()

func _process(delta: float) -> void:
	var minutes = int(game_timer.time_left / 60)
	var seconds = int(game_timer.time_left) % 60
	timer_display.text = "%02d:%02d" % [minutes, seconds]
	if not alert and game_timer.time_left < 20.0:
		ship.alert()
		alert = true

func _out_of_time() -> void:
	score = score / 2
	emit_signal("score_change", score)
	_ending_anim_start()

func _launch() -> void:
	_ending_anim_start()

func _ending_anim_start() -> void:
	$Timer.start(2)
	$Timer.connect("timeout", Callable(self, "_ending_anim_finished"))
	$CanvasLayer.add_child(fade.instantiate())
	player.change_state("NoControl")
	current_state = null

func _ending_anim_finished() -> void:
	SceneChanger.game_finish(score)

func _process_move(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		var inter = player.get_interactable()
		if inter:
			inter.trigger()
			return
		target.position.x = aim_min
		player.start_cast()
		current_state = state.cast
		cast_time = 0.0
		return

func _process_cast(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		player.cancel()
		current_state = state.move
	if Input.is_action_just_released("action"):
		player.release_cast()
		current_state = state.wait
		return
	cast_time += delta * aim_speed
	var distance = fmod(cast_time, 2.0)
	if distance > 1.0:
		distance = 2.0 - distance
	distance = ease(distance, 2.5)
	distance = distance * (aim_max - aim_min) + aim_min
	target.position.x = distance
	
func _process_wait(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		player.reel(false)
	
	if Input.is_action_just_released("action"):
		player.wait()
		
	if Input.is_action_pressed("action"):
		lure.global_position -= player.to_local(lure.global_position).normalized() * reel_speed * delta
	if(!lure.monitoring):
		return
	if Input.is_action_just_pressed("cancel"):
		_cancel()
		return


func _process_lose():
	if $Timer.is_stopped():
		current_state = state.move


func add_score(points: int):
	score += points
	emit_signal("score_change", score)

func _on_tension_changed(t: float):
	tension = t
	var clamp_t = clamp(t / max_tension, 0.0, 1.0)
	tension_bar.set_tension(clamp_t)

func _on_danger_changed(d: float):
	tension_bar.set_danger(d)

func _on_star_caught(star: Star) -> void:
	add_score(star.score * score_multiplier)

func _on_hook_lost():
	hooks -= 1
	reels_display.adjust(hooks)
	if hooks <= 0:
		_ending_anim_start()
		return

func _on_fight_started() -> void:
	tension_bar.visible = true

func _on_fight_ended() -> void:
	tension_bar.visible = false

func _cancel() -> void:
	$Timer.start(1.1)
	player.show_cancel()
	current_state = state.lose
