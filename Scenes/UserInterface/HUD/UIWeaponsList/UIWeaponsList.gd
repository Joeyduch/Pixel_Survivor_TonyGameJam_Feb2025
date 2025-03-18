class_name UIWeaponsList extends Control

var ui_border_icon_scene:PackedScene = preload("res://Scenes/UserInterface/UIComponents/UIBorderIcon/UIBorderIcon.tscn")

@onready var container:HBoxContainer = $HBoxContainer



func update_list(weapons:Array[BaseWeapon]) -> void:
	if not container:
		push_error("No HBoxContainer in UIWeaponsList")
		return
	# clear children
	for child:Node in container.get_children():
		child.queue_free()
	# make new icons
	for base_weapon:BaseWeapon in weapons:
		var weapon_icon:UIBorderIcon = ui_border_icon_scene.instantiate()
		container.add_child(weapon_icon)
		if base_weapon.icon:
			weapon_icon.set_icon(base_weapon.icon)
