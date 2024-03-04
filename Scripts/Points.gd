extends Label

func _ready() -> void:
	update_total(0)

func update_total(score: int) -> void:
	text = str(score)


func _on_Main_score_change(score: int) -> void:
	update_total(score)
