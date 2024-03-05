extends Node

enum state { move, cast, wait, fight, lose, land }

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
var cast_time: float

export var max_tension: float
export var tension_decay: float
export var tension_multiplier: float

export var hooks: int

signal hooks_change
signal score_change
signal tension_change
signal game_over

var tension: float
var score:int = 0
var current_state = state.move

var lure: Lure
var player: Player
var target: Node2D
var lure_origin: Node2D
var tension_bar: Node2D
var bar_fill: Node2D
var star_highlight: StarHighlight
var sfx: AudioStreamPlayer


func _ready() -> void:
	randomize()
	lure = $Player/Lure
	player = $Player
	target = $Player/Target
	tension_bar = $Player/TensionBar
	bar_fill = $Player/TensionBar/TensionBarFill
	star_highlight = $Player/StarHighlight
	sfx = $SfxPlayer
	tension_bar.visible = false

func _process(delta: float) -> void:
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
	distance = aim_lerp_curve.interpolate_baked(distance)
	distance = distance * (position_max - position_min) + position_min
	target.position.x = distance
	
func _process_wait(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		player.cancel()
		current_state = state.move
		return
	
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
	var overlaps = lure.get_overlapping_areas()
	if overlaps.size() == 0:
		return
	
	var highest_scoring = overlaps[0]
	for overlap in overlaps:
		if overlap.score > highest_scoring.score:
			highest_scoring = overlap
	current_state = state.fight
	tension_bar.visible = true
	player.wait(false)
	lure.add_star(highest_scoring)
	highest_scoring.hook()
	

func _process_fight(delta):
	var intensity = lure.hooked.intensity
	var reel_speed_mod = lure.hooked.reel_speed_mod
	var inv = 1.0 - intensity
	var escape = lure.hooked.escape_speed * escape_speed_mod
	var t = tension
	if Input.is_action_pressed("action"):
		player.reel(true)
		t += intensity * delta * tension_multiplier
		lure.position.x -= reel_speed * delta * inv * reel_speed_mod
	else:
		player.wait(false)
		t -= tension_decay * delta
		lure.position.x += escape * delta * inv
	
	set_tension(t)
	 
	if lure.position.x < position_min:
		$Timer.start(2.0)
		current_state = state.land
		land_star()
		return
	
	if tension > max_tension or lure.position.x > position_max + 20:
		$Timer.start(2.5)
		current_state = state.lose
		lose_hook()
		return
	tension = clamp(tension, 0, max_tension)

func _process_lose():
	if $Timer.is_stopped():
		if hooks <= 0:
			emit_signal("game_over", score)
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
	bar_fill.scale.y = clamp(- t / max_tension, -1.0, 0.0)

func land_star():
	set_tension(0)
	tension_bar.visible = false
	player.land()
	var star = lure.remove_star()
	star.unhook()
	star_highlight.add_star(star)
	add_score(star.score)

func lose_hook():
	set_tension(0)
	tension_bar.visible = false
	lure.remove_star().queue_free()
	player.break_line()
	hooks -= 1
	emit_signal("hooks_change", hooks)
	if hooks == 0:
		pass
