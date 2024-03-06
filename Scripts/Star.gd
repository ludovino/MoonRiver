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

func _ready() -> void:
	audio_source = AudioStreamPlayer.new()
	audio_source.pitch_scale = audio_pitch_modulate
	audio_source.volume_db = 1.0
	audio_source.bus = "Sfx"
	add_child(audio_source)

func hook():
	print("hook")
	hooked = true
	audio_source.stream = catch
	audio_source.play(0)

func unhook():
	hooked = false

func _process(delta: float) -> void:
	if not hooked:
		return
	var prev_intensity = intensity
	time += delta * pulse_speed
	if time >= 1.0:
		time -= 1.0
	intensity = pulse_graph.interpolate(time)
	if prev_intensity < 0.25 and intensity >= 0.25:
		audio_source.stream = struggle
		audio_source.play(0)
