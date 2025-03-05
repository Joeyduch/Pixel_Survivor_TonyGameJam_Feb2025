class_name UpgradesMenu extends Control

signal upgrade_chosen(upgrade:BaseUpgrade)

var ui_upgrade_scene:PackedScene = preload("res://Scenes/UserInterface/Menus/Upgrades/UIUpgrade/UIUpgrade.tscn")

# TEST TEMPORARY TEST
@onready var res_upgrade_1:BaseUpgrade = preload("res://Resources/Upgrades/LifeHealUpgradeI.tres")
@onready var res_upgrade_2:BaseUpgrade = preload("res://Resources/Upgrades/LifeHealUpgradeII.tres")

@onready var ui_upgrade_container:HBoxContainer = $VBoxContainer/HBoxContainer
@onready var description_label:Label = $VBoxContainer/Description

@onready var upgrades_list:Array[BaseUpgrade] = [res_upgrade_1, res_upgrade_2]: set = set_upgrades_list
var selected_upgrade:int = 0: set = set_selected_upgrade



func _ready() -> void:
	upgrades_list = upgrades_list



func set_selected_upgrade(upgrade_index:int) -> void:
	var children:Array[Node] = ui_upgrade_container.get_children()
	# unblink old UIUpgrade
	if selected_upgrade < children.size():
		var ui_upgrade:UIUpgrade = children[selected_upgrade]
		ui_upgrade.unblink()
	# update value
	selected_upgrade = clamp(upgrade_index, 0, max(0, children.size()-1))
	# blink new UIUpgrade
	if selected_upgrade < children.size():
		var ui_upgrade:UIUpgrade = children[selected_upgrade]
		ui_upgrade.blink()
		# update label
		description_label.text =  "%s: %s" % [ui_upgrade.holding_upgrade.upgrade_name, ui_upgrade.holding_upgrade.description]


func set_upgrades_list(upgrades:Array[BaseUpgrade]) -> void:
	upgrades_list = upgrades
	selected_upgrade = 0
	
	clear_children()
	generate_ui_upgrades()



func clear_children() -> void:
	for child:Node in ui_upgrade_container.get_children():
		child.queue_free()


func generate_ui_upgrades() -> void:
	var index:int = 0
	for upgrade:BaseUpgrade in upgrades_list:
		if not upgrade: continue
		
		var ui_upgrade:UIUpgrade = ui_upgrade_scene.instantiate()
		ui_upgrade.holding_upgrade = upgrade
		ui_upgrade_container.add_child(ui_upgrade)
		
		if index == selected_upgrade:
			ui_upgrade.blink()
		index += 1


func select_next() -> void:
	selected_upgrade += 1

func select_previous() -> void:
	selected_upgrade -= 1

func choose_upgrade() -> void:
	if selected_upgrade < upgrades_list.size():
		var chosen_upgrade:BaseUpgrade = upgrades_list[selected_upgrade]
		upgrade_chosen.emit(chosen_upgrade)
