class_name GameOver
extends Node

const score_string = "fuel units gathered: %s"

signal replay
signal menu

func _ready() -> void:
	$CenterContainer/VBoxContainer/CenterContainer/PlayAgain.grab_focus()

func set_score(score: int):
	$CenterContainer/VBoxContainer/ScoreCtn/Score.text = score_string % score
	if(score > 10000):
		$AnimationPlayer.play("high_score")
	elif score > 1000:
		$AnimationPlayer.play("med_score")
	else:
		$AnimationPlayer.play("low_score")


func _on_PlayAgain_pressed() -> void:
	emit_signal("replay")


func _on_MainMenu_pressed() -> void:
	emit_signal("menu")
