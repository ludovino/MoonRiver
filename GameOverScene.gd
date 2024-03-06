class_name GameOver
extends Control

const score_string = "fuel units gathered: %s"

signal replay
signal menu

func _ready() -> void:
	$CenterContainer/VBoxContainer/CenterContainer/PlayAgain.grab_focus()

func set_score(score: int):
	$CenterContainer/VBoxContainer/ScoreCtn/Score.text = score_string % score


func _on_PlayAgain_pressed() -> void:
	emit_signal("replay")


func _on_MainMenu_pressed() -> void:
	emit_signal("menu")
