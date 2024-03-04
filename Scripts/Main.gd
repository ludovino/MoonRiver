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

signal lost_hook
signal score_change
signal tension_change

var tension: float

var current_state = state.move

var lure: Lure
var player: Player
var target: Node2D
var lure_origin: Node2D

func _ready() -> void:
	lure = $Player/Lure
	player = $Player
	target = $Player/Target

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
	player.wait(false)
	lure.add_star(highest_scoring)
	

func _process_fight(delta):
	var intensity = lure.hooked.intensity
	var inv = 1.0 - intensity
	var escape = lure.hooked.escape_speed * escape_speed_mod
	if Input.is_action_pressed("action"):
		player.reel(true)
		tension += intensity * delta * tension_multiplier
		lure.position.x -= reel_speed * delta * inv
		lure.position.x += escape * delta * intensity
	else:
		player.wait(false)
		tension -= tension_decay * delta
		lure.position.x += escape * delta * inv
	emit_signal("tension_change", tension)
	
	if tension > max_tension:
		lose_hook()
		return
	tension = clamp(tension, 0, max_tension)

func _process_lose():
	pass

func _process_land():
	pass

func lose_hook():
	lure.remove_star().queue_free()
	hooks -= 1
	if hooks == 0:
		pass
