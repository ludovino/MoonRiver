extends Node

enum state { move, cast, wait, fight, lose, land }
enum Layers { DEFAULT = 0, STARS = 1, LURE = 2, EFFECTORS = 4 }
var progress : Progression
export(Resource) var prog_res : Resource

export var player_speed: float
export var position_min: float
export var position_max: float
export var cast_x_curve: Curve
export var cast_y_curve: Curve
export var cast_height: float

export var aim_lerp_curve: Curve
export var aim_min: float
export var aim_max: float
export var aim_speed: float

export var reel_speed: float
export var escape_speed_mod: float
export var fight_speed_mod: float
var cast_time: float

export var max_tension: float
export var tension_decay: float
export var tension_multiplier: float
export var score_multiplier: int

export var hooks: int

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

func _ready() -> void:
	fade = load("res://PackedScenes/FadeOut.tscn")
	if prog_res == null:
		progress = load("user://progression.tres") as Progression
	else:
		progress = prog_res as Progression
	lure = $Player/Lure
	game_timer = $GameTime
	game_timer.connect("timeout", self, "_out_of_time")
	timer_display = $SideBar/VBoxContainer/Timer
	player = $Player
	target = $Player/Target
	tension_bar = $TensionBar
	star_highlight = $Player/StarHighlight
	reels_display = $SideBar/VBoxContainer/Center/Reels
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
	$Alert.enabled = game_timer.time_left < 20.0 && game_timer.time_left > 0
		
	match current_state:
		state.move:
			_process_move(delta)
		state.cast:
			_process_cast(delta)
		state.wait:
			_process_wait(delta)
		state.fight:
			_process_fight(delta)
		state.lose:
			_process_lose()
		state.land:
			_process_land()
		_:
			if $Timer.is_stopped(): current_state = state.move

func _out_of_time() -> void:
	_ending_anim_start()

func _ending_anim_start() -> void:
	$Timer.start(2)
	$Timer.connect("timeout", self, "_ending_anim_finished")
	add_child(fade.instance())
	match current_state:
		state.move:
			player.idle()
		state.cast:
			player.break_line()
		state.wait:
			player.idle()
		state.fight:
			lure.remove_star().queue_free()
			player.break_line()
		state.lose:
			player.idle()
		state.land:
			player.idle()
	current_state = null

func _ending_anim_finished() -> void:
	emit_signal("game_over", score)

func _process_move(delta: float) -> void:
	# cast
	if Input.is_action_just_pressed("action"):
		target.position.x = position_min
		player.start_cast()
		current_state = state.cast
		cast_time = 0.0
		return
	# move
	var move: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		move += Vector2.UP * player_speed * delta
		player.walk(true)
	if Input.is_action_pressed("down"):
		move += Vector2.DOWN * player_speed * delta
		player.walk(false)
	if move.length_squared() == 0.0:
		player.idle()
	else:
		player.position += move
	player.position.y = clamp(player.position.y, position_min, position_max)
	

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
		lure.position.x -= reel_speed * delta
		if lure.position.x < position_min:
			player.cancel()
			current_state = state.move
	if(!lure.monitoring):
		return
	if Input.is_action_just_pressed("cancel"):
		_cancel()
		return
	var overlaps = lure.get_overlapping_areas()
	if overlaps.size() == 0:
		return

func _process_fight(delta):
	var intensity = lure.hooked.intensity
	var rs_bonus : float = 1.0 + (progress.pull_level / 6.0)
	var reel_speed_mod = lure.hooked.reel_speed_mod * rs_bonus * fight_speed_mod
	var inv = 1.0 - intensity
	var es_bonus = 1.0 + ((6.0 - progress.escape_level) / 6.0)
	var escape : float = lure.hooked.escape_speed * escape_speed_mod * es_bonus
	var t = tension
	if Input.is_action_pressed("action"):
		player.reel(true)
		var tf_bonus = 1.0 - (progress.escape_level / 8.0)
		t += intensity * delta * tension_multiplier * tf_bonus
		lure.position.x -= reel_speed * delta * inv * reel_speed_mod
		tension_bar.set_danger(intensity)
	else:
		tension_bar.set_danger(0.0)
		player.wait(false)
		var td_bonus = 1.0 + (progress.decay_level / 6.0)
		t -= tension_decay * td_bonus * delta
		lure.position.x += escape * delta * inv
	
	set_tension(t)
	 
	if lure.position.x < aim_min:
		land_star()
		return
	
	if tension > max_tension or lure.position.x > aim_max + 20:
		lose_hook()
		return
	tension = clamp(tension, 0, max_tension)

func _process_lose():
	if $Timer.is_stopped():
		if hooks <= 0:
			_ending_anim_start()
			return
		current_state = state.move

func _process_land():
	if $Timer.is_stopped():
		current_state = state.move

func add_score(points: int):
	score += points
	emit_signal("score_change", score)

func set_tension(t: float):
	tension = t
	emit_signal("tension_change", t)
	tension_bar.set_tension(clamp(t / max_tension, 0.0, 1.0))

func land_star():
	$Timer.start(1.0)
	current_state = state.land
	set_tension(0)
	tension_bar.hide()
	player.land()
	var star = lure.remove_star()
	star.unhook()
	star_highlight.add_star(star)
	add_score(star.score * score_multiplier)

func lose_hook():
	$Timer.start(1.8)
	print("lose")
	current_state = state.lose
	set_tension(0)
	tension_bar.hide()
	lure.remove_star().queue_free()
	player.break_line()
	hooks -= 1
	reels_display.adjust(hooks)
	if hooks == 0:
		pass

func _catch_star(star : Star) -> void:
	current_state = state.fight
	tension_bar.show()
	set_tension(0)
	player.wait(false)
	lure.add_star(star)
	star.hook()

func _cancel() -> void:
	$Timer.start(1.1)
	player.show_cancel()
	current_state = state.lose
	
func _on_Lure_area_entered(area: Area2D) -> void:
	match current_state:
		state.wait:
			if area.is_in_group("star"):
				call_deferred("_catch_star", area as Star)
			elif area.is_in_group("cancel_lure"):
				_cancel()
		state.fight:
			if area.is_in_group("star"):
				pass
			elif area.is_in_group("cancel_lure"):
				lose_hook()
