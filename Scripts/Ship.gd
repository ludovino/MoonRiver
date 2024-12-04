class_name Ship
extends Sprite

enum { CLOSED, OPENING, OPEN }
enum { ALERT, OK }
var alert_state := OK
var door_state := CLOSED
var timer : Timer
export var alert_color : Color
export var ok_color : Color

signal player_boarded

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "close_door")
	timer.one_shot = true

func alert() -> void:
	if alert_state == OK:
		alert_state = ALERT
		$Button.modulate = alert_color
		$AnimationPlayer.play("alert")

func cancel_alert() -> void:
	if alert_state == ALERT:
		alert_state = OK
		$AnimationPlayer.play("idle")

func _on_DoorTrigger_triggered() -> void:
	match door_state:
		CLOSED: 
			_start_open_door()
		OPEN:
			emit_signal("player_boarded")

func _start_open_door():
	door_state = OPENING
	$DoorTrigger.monitorable = false
	$AirLockParticles.restart()
	$AirLockParticles.emitting = true
	$AirLockParticles2.restart()
	$AirLockParticles2.emitting = true
	$DoorOpen.play()
	$Button.modulate = alert_color
	var tween = create_tween()
	tween.tween_interval(0.7)
	tween.tween_callback(self,"_open_door")

func _open_door() -> void:
	$DoorTrigger.monitorable = true
	if alert_state == OK: timer.start(5)
	door_state = OPEN
	$Button.modulate = ok_color
	$DoorThud.play()
	$Door.visible = true

func close_door() -> void:
	if door_state == CLOSED: return
	$DoorTrigger.monitorable = true
	door_state = CLOSED
	$Button.modulate = ok_color
	$DoorThud.play()
	$Door.visible = false
	
