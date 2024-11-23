extends VBoxContainer


var progress : Progression

export var unlock_res : Resource
export var fill_res : Resource
export var decay_res : Resource
export var pull_res : Resource
export var escape_res : Resource
export var catch_res : Resource
export var oxygen_res : Resource
export var reels_res : Resource

var unlock_button : Button
var fill_button : Button
var decay_button : Button
var pull_button : Button
var escape_button : Button
var catch_button : Button
var oxygen_button : Button
var reels_button : Button

var units_label : Label

var unlock_resources : Array
var unlock_buttons : Array

signal unlock_purchased

func _ready() -> void:
	progress = ResourceLoader.load("user://progression.tres") as Progression
	units_label = $UnitsCount
	unlock_button = $EnginePower
	fill_button = $Grid/FillSpeed
	decay_button = $Grid/DecaySpeed
	pull_button = $Grid/PullSpeed
	escape_button = $Grid/EscapeReduction
	catch_button = $Grid/IncreasedCatch
	oxygen_button = $Grid/Oxygen
	reels_button = $Reels
	unlock_buttons = [
		unlock_button, 
		fill_button, 
		decay_button, 
		pull_button, 
		escape_button,
		catch_button,
		oxygen_button,
		reels_button]
	unlock_resources = [
		unlock_res, 
		fill_res, 
		decay_res, 
		pull_res, 
		escape_res,
		catch_res,
		oxygen_res,
		reels_res]
	for i in unlock_buttons.size():
		var btn = unlock_buttons[i] as Button
		btn.connect("pressed", self,"_purchase", [i])
	_update_all()

func _update_all() -> void:
	units_label.text = "%d units" % progress.units
	var unlocks_counts = [
		progress.planets_unlocked,
		progress.fill_level,
		progress.decay_level,
		progress.pull_level,
		progress.escape_level,
		progress.catch_level,
		progress.oxygen_level,
		progress.reels_level
	]
	for i in range(unlock_buttons.size()):
		_update_button(unlock_buttons[i], unlocks_counts[i], unlock_resources[i].costs)

func _update_button(button : Button, unlocks : int, costs : Array):
	if unlocks >= costs.size():
		button.disabled = true
		button.text = "MAX"
		return
	var cost = costs[unlocks];
	
	button.disabled = cost > progress.units
	button.text = String(costs[unlocks])

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
