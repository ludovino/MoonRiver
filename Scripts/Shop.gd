extends VBoxContainer

var progress : Progression
export var button_scene : PackedScene
export var unlock_res : Resource
export var fill_res : Resource
export var decay_res : Resource
export var pull_res : Resource
export var escape_res : Resource
export var catch_res : Resource
export var oxygen_res : Resource
export var reels_res : Resource

var units_label : Label

var unlock_resources : Array
var unlock_buttons : Array

signal unlock_purchased

func _ready() -> void:
	progress = ResourceLoader.load("user://progression.tres") as Progression
	units_label = $UnitsCount
	unlock_buttons = []
	unlock_resources = [
		unlock_res, 
		fill_res, 
		decay_res, 
		pull_res, 
		escape_res,
		catch_res,
		oxygen_res,
		reels_res]
	for i in unlock_resources.size():
		var ug = unlock_resources[i] as Upgrade
		var btn = button_scene.instance() as Button
		btn.icon = ug.icon
		btn.hint_tooltip = ug.display_name
		unlock_buttons.append(btn)
		$Grid.add_child(btn)
		btn.connect("pressed", self,"_purchase", [i])
		btn.connect("focus_entered", self, "_focus_beep")
		btn.connect("pressed", self, "_select_beep")
	_update_all()

func _update_all() -> void:
	units_label.text = "%d units" % progress.units
	for i in range(unlock_buttons.size()):
		var res = unlock_resources[i] as Upgrade
		var button = unlock_buttons[i]
		var unlock_level = progress.get(res.prog_name)
		_update_button(button, unlock_level, res.costs)

func _update_button(button : Button, unlocks : int, costs : Array):
	if unlocks >= costs.size():
		button.disabled = true
		button.text = "MAX"
		return
	var cost = costs[unlocks]
	
	button.disabled = cost > progress.units
	button.text = String(costs[unlocks])

func _focus_beep() -> void:
	$ShopBoop.pitch_scale = 1.0
	$ShopBoop.play()
	
func _select_beep() -> void:
	$ShopBoop.pitch_scale = 1.05
	$ShopBoop.play()

func _purchase(idx : int) -> void:
	var res = unlock_resources[idx] as Upgrade
	var current = progress.get(res.prog_name)
	var cost = res.costs[current]
	progress.units -= cost
	progress.set(res.prog_name, current + 1)
	ResourceSaver.save("user://progression.tres", progress)
	_update_all()
	if idx == 0:
		emit_signal("unlock_purchased")
