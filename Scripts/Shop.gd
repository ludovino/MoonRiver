extends Panel

var progress : Progression
export(Array, Resource) var resources : Array
export var upgrade_scene : PackedScene
export(NodePath) var upgrade_container_path : NodePath
var upgrade_container : Control
var units_label : Label
var progression : Progression

signal unlock_purchased

func _ready() -> void:
	progression = load("user://progression.tres")
	upgrade_container = get_node(upgrade_container_path)
	for res in resources:
		var upg = res as Upgrade
		var up_d = upgrade_scene.instance() as UpgradeDisplay
		upgrade_container.add_child(up_d)
		up_d.upgrade = upg
		up_d.connect("purchased", self, "_update_all")
	_update_all()

func _update_all() -> void:
	$Panel/Units.text = str(progression.units)
	for child in upgrade_container.get_children():
		child.update_display() 

func _focus_beep() -> void:
	$ShopBoop.pitch_scale = 1.0
	$ShopBoop.play()
	
func _select_beep() -> void:
	$ShopBoop.pitch_scale = 1.05
	$ShopBoop.play()
