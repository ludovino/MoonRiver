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

var cast_time: float 

var current_state = state.move

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	match current_state:
		state.move:
			_process_move(delta)
		state.cast:
			_process_cast(delta)
		state.wait:
			_process_wait()
		state.fight:
			_process_fight()
		state.lose:
			_process_lose()
		state.land:
			_process_land()

func _process_move(delta: float) -> void:
	# cast
	if Input.is_action_just_pressed("action"):
		$Player.start_cast()
		current_state = state.cast
		cast_time = 0.0
		return
	# move
	var move: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("up"):
		move += Vector2.UP * player_speed * delta
		$Player.walk(true)
	if Input.is_action_pressed("down"):
		move += Vector2.DOWN * player_speed * delta
		$Player.walk(false)
	if move.length_squared() == 0.0:
		$Player.idle()
	else:
		$Player.position += move
	$Player.position.y = clamp($Player.position.y, position_min, position_max)
	
func _process_cast(delta: float) -> void:
	if Input.is_action_just_pressed("cancel"):
		$Player.cancel()
		current_state = state.move
	if Input.is_action_just_released("action"):
		$Player.release_cast()
		return
	cast_time += delta * aim_speed
	var distance = fmod(cast_time, 2.0)
	if distance > 1.0:
		distance = 2.0 - distance
	distance = aim_lerp_curve.interpolate_baked(distance)
	distance = distance * (position_max - position_min) + position_min
	$Player/Target.position.x = distance
	
	
	
func _process_wait():
	if Input.is_action_just_pressed("cancel"):
		$Player.cancel()
		current_state = state.move

func _process_fight():
	pass

func _process_lose():
	pass

func _process_land():
	pass
