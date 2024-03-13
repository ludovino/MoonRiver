class_name Star
extends Area2D

export var pulse_speed: float
export var pulse_graph: Curve
export var score: int
export var escape_speed: float
export var magnitude: float

export(AudioStreamSample) var catch: AudioStreamSample
export(AudioStreamSample) var struggle: AudioStreamSample
export(float, 0.5, 2) var audio_pitch_modulate: float = 1.0

export(float, 0, 1.0) var reel_speed_mod: float = 0.9

var time: float
var intensity: float
var hooked: bool = false

var audio_source: AudioStreamPlayer
var hook_sound: AudioStreamPlayer

func _ready() -> void:
	audio_source = AudioStreamPlayer.new()
	audio_source.pitch_scale = audio_pitch_modulate
	audio_source.volume_db = 1.0
	audio_source.bus = "Sfx"
	add_child(audio_source)

func hook():
	hooked = true
	hook_sound = AudioStreamPlayer.new()
	hook_sound.pitch_scale = audio_pitch_modulate
	add_child(hook_sound)
	hook_sound.stream = catch
	hook_sound.play(0)
	audio_source.stream = struggle
	audio_source.play(0)

func unhook():
	hooked = false
	audio_source.stop()

func _process(delta: float) -> void:
	if not hooked:
		return
	time += delta * pulse_speed
	if time >= 1.0:
		time -= 1.0
		audio_source.stream = struggle
		audio_source.play(0)
	intensity = pulse_graph.interpolate(time)
	audio_source.volume_db = (intensity * 30) - 30
