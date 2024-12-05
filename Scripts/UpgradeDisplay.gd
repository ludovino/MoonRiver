class_name UpgradeDisplay
extends Control

export var upgrade_resource : Resource
var upgrade : Upgrade

onready var title : Label = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/Title
onready var description : RichTextLabel = $Panel/HBoxContainer/VBoxContainer2/Description
onready var icon : TextureRect = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/Icon
#onready var price : Label = $Panel/HBoxContainer/VBoxContainer2/Price
onready var progress : ProgressDisplay = $Panel/HBoxContainer/VBoxContainer/Progress
onready var button : Button = $Panel/HBoxContainer/VBoxContainer2/Button

var progression : ProgressionRes

signal purchased

func _ready() -> void:
	progression = Progression.res

func update_display() -> void:
	var upgrade_level = progression.get(upgrade.prog_name)
	title.text = upgrade.display_name
	description.text = upgrade.description
	icon.texture = upgrade.icon
	var cost = _current_cost()
	button.text = str(cost) if cost > 0 else "MAX"
	button.disabled = cost > progression.units or cost < 0
	button.connect("pressed", self, "purchase")
	progress.setup(upgrade_level, upgrade.costs.size())

func _current_cost() -> int:
	var upgrade_level = progression.get(upgrade.prog_name)
	if upgrade_level >= upgrade.costs.size():
		return -1
	var cost = upgrade.costs[upgrade_level]
	return cost
	
func purchase() -> void:
	var upgrade_level = progression.get(upgrade.prog_name)
	var cost = _current_cost()
	if cost > progression.units:
		return
	progression.set(upgrade.prog_name, upgrade_level + 1)
	progression.units -= cost
	Progression.save()
	emit_signal("purchased")
