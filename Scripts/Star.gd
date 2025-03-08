class_name Star
extends Area2D

@export var pulse_speed: float
@export var pulse_graph: Curve
@export var score: int
@export var escape_speed: float
@export var magnitude: float
@export var min_level: int = 0 
@export var catch: AudioStreamWAV
@export var struggle: AudioStreamWAV
@export var audio_pitch_modulate: float = 1.0 # (float, 0.5, 2)

@export var reel_speed_mod: float = 0.9 # (float, 0, 1.0)

var time: float
var intensity: float
var hooked: bool = false
var data: StarData
var audio_source: AudioStreamPlayer
var hook_sound: AudioStreamPlayer

func _ready() -> void:
	audio_source = AudioStreamPlayer.new()
	audio_source.pitch_scale = audio_pitch_modulate
	audio_source.volume_db = 1.0
	audio_source.bus = "Sfx"
	
	hook_sound = AudioStreamPlayer.new()
	hook_sound.bus = "Sfx"
	add_child(audio_source)

func hook():
	if hooked: return
	hooked = true
	hook_sound.pitch_scale = audio_pitch_modulate
	add_child(hook_sound)
	hook_sound.stream = catch
	hook_sound.play(0)
	audio_source.stream = struggle
	audio_source.play(0)

func unhook():
	hooked = false
	audio_source.stop()

func setup(color : Color, prog_level : int, starData : StarData) -> void:
	_assign_data(starData)
	modulate = color
	#if prog_level < min_level:
	#	modulate.a = 0.1
	#	monitorable = false
	if starData.fx_scene != null:
		add_child(data.fx_scene.instantiate())

func _assign_data(starData : StarData):
	data = starData
	pulse_graph = data.pulse_graph
	pulse_speed = data.pulse_speed
	score = data.score
	escape_speed = data.escape_speed
	magnitude = data.magnitude
	min_level = data.min_level
	audio_pitch_modulate = data.audio_pitch_modulate
	reel_speed_mod = data.reel_speed_mod
	$Sprite2D.frames = data.frames
	$Sprite2D.play(data.animation)
	$CollisionShape2D.shape.radius = data.radius

func _process(delta: float) -> void:
	if not hooked:
		return
	time += delta * pulse_speed
	if time >= 1.0:
		time -= 1.0
		audio_source.stream = struggle
		audio_source.play(0)
	intensity = pulse_graph.sample(time)
	audio_source.volume_db = (intensity * 30) - 30
