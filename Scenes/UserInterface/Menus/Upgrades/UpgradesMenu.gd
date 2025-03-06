class_name UpgradesMenu extends Control

signal upgrade_chosen(upgrade:BaseUpgrade)

var ui_upgrades_list_scene:PackedScene = preload("res://Scenes/UserInterface/Menus/Upgrades/UIUpgradesList/UIUpgradesList.tscn")

@onready var ui_upgrade_container:HBoxContainer = $VBoxContainer/HBoxContainer
@onready var description_label:Label = $VBoxContainer/Description

var upgrades_list:Array[UpgradesList] = []: set = set_upgrades_list
var selected_upgrade:int = 0: set = set_selected_upgrade



func _ready() -> void:
	upgrades_list = [
		preload("res://Resources/Upgrades/UpgradesLists/LifeUpgradesList.tres"),
		preload("res://Resources/Upgrades/UpgradesLists/CharacterUpgradesList.tres"),
		preload("res://Resources/Upgrades/UpgradesLists/WeaponUpgradesList.tres")
	]



func set_selected_upgrade(upgrade_index:int) -> void:
	var children:Array[Node] = ui_upgrade_container.get_children()
	# unblink old UIUpgrade
	if selected_upgrade < children.size():
		var ui_upgrades_list:UIUpgradesList = children[selected_upgrade]
		ui_upgrades_list.unblink()
	# update value
	selected_upgrade = clamp(upgrade_index, 0, max(0, children.size()-1))
	# blink new UIUpgrade
	if selected_upgrade < children.size():
		var ui_upgrades_list:UIUpgradesList = children[selected_upgrade]
		ui_upgrades_list.blink()
		# update label (directly using upgrades_list as a 'band-aid' solution
		# or else the text doesn't display at first/_ready
		description_label.text = upgrades_list[selected_upgrade].description


func set_upgrades_list(upgrades:Array[UpgradesList]) -> void:
	upgrades_list = upgrades
	selected_upgrade = 0
	
	clear_children()
	generate_ui_upgrades()


func clear_children() -> void:
	for child:Node in ui_upgrade_container.get_children():
		child.queue_free()


func generate_ui_upgrades() -> void:
	var index:int = 0
	for upgrade:UpgradesList in upgrades_list:
		if not upgrade: continue
		
		var ui_upgrade:UIUpgradesList = ui_upgrades_list_scene.instantiate()
		ui_upgrade.holding_upgrades_list = upgrade
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
		var chosen_upgrades_list:UpgradesList = upgrades_list[selected_upgrade]
		# roll random item
		var upgrade_selector:RandomSelector = RandomSelector.new(chosen_upgrades_list.get_full_list())
		var random_upgrade:BaseUpgrade = upgrade_selector.roll_item()
		upgrade_chosen.emit(random_upgrade)
