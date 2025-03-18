class_name NewWeaponMenu extends Control

signal weapon_confirmed(weapon:BaseWeapon)

var base_weapon_scene:PackedScene = preload("res://Scenes/Components/Weapons/BaseWeapon/BaseWeapon.tscn")
var selection_index:int = 0: set = set_selection_index

@onready var container:GridContainer = $VBoxContainer/GridContainer



func _ready() -> void:
	selection_index = 0



func set_selection_index(index:int) -> void:
	var container_children:Array[Node] = container.get_children()
	if container_children.size() <= 0: return
	
	# unblink previous selection
	var selected_icon:UIBorderIcon = container_children[selection_index]
	selected_icon.unblink()
	
	# wrap index around amount of icons
	index = index % container_children.size()
	if index < 0:
		index += container_children.size()
	
	# set selection index
	selection_index = index
	
	# blink new selection
	selected_icon = container_children[selection_index]
	selected_icon.blink()


func select_next() -> void:
	selection_index += 1
	
func select_previous() -> void:
	selection_index -= 1

func jump_next() -> void:
	selection_index += container.columns

func jump_previous() -> void:
	selection_index -= container.columns


func confirm_selection() -> void:
	var icon:Texture2D = get_selected_icon()
	var weapon:BaseWeapon = base_weapon_scene.instantiate()
	if icon:
		weapon.icon = icon
	weapon_confirmed.emit(weapon)


func get_selected_icon() -> Texture2D:
	var container_children:Array[Node] = container.get_children()
	var child:Node = container_children[selection_index]
	
	if child is UIBorderIcon:
		return child.ui_icon.texture
	else:
		return null
