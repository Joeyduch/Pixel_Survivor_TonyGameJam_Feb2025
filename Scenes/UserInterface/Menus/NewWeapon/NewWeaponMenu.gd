class_name NewWeaponMenu extends Control

signal weapon_confirmed(weapon:BaseWeapon)

var base_weapon_scene:PackedScene = preload("res://Scenes/Components/Weapons/BaseWeapon/BaseWeapon.tscn")
var ui_border_icon_scene:PackedScene = preload("res://Scenes/UserInterface/UIComponents/UIBorderIcon/UIBorderIcon.tscn")

var selection_index:int = 0: set = set_selection_index
var weapon_preset_list:Array[WeaponPreset] = [
	preload("res://Resources/WeaponPresets/WPPistol.tres"),
	preload("res://Resources/WeaponPresets/WPShotgun.tres"),
	preload("res://Resources/WeaponPresets/WPSMG.tres"),
	preload("res://Resources/WeaponPresets/WPMachineGun.tres"),
]

@onready var container:GridContainer = $VBoxContainer/GridContainer
@onready var preset_name_label:Label = $VBoxContainer/PresetName
@onready var damage_modifier_value_label:Label = $VBoxContainer/StatsContainer/DamageModifValue
@onready var spread_value_label:Label = $VBoxContainer/StatsContainer/SpreadValue
@onready var cooldown_value_label:Label = $VBoxContainer/StatsContainer/CooldownValue
@onready var projectiles_value_label:Label = $VBoxContainer/StatsContainer/ProjectilesValue



func _ready() -> void:
	setup_presets_ui()
	selection_index = 0



#	--------------------
#	SET-GET
#	--------------------

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
	# setup new values on labels
	var preset:WeaponPreset = weapon_preset_list[selection_index]
	if preset:
		preset_name_label.text = preset.name
		damage_modifier_value_label.text = str(preset.damage_modifier)
		spread_value_label.text = str(preset.base_spread)
		cooldown_value_label.text = str(preset.base_cooldown_time)
		projectiles_value_label.text = str(preset.base_projectiles_per_shot)


func select_next() -> void:
	selection_index += 1
	
func select_previous() -> void:
	selection_index -= 1

func jump_next() -> void:
	selection_index += container.columns

func jump_previous() -> void:
	selection_index -= container.columns



#	--------------------
#	METHODS
#	--------------------

func setup_presets_ui() -> void:
	selection_index = 0
	
	for child:Node in container.get_children():
		child.queue_free()
	
	var index:int = 0
	for preset:WeaponPreset in weapon_preset_list:
		var border_icon:UIBorderIcon = ui_border_icon_scene.instantiate()
		border_icon.icon = preset.icon
		container.add_child(border_icon)
		
		if index == selection_index:
			border_icon.blink()
		
		index += 1


func get_weapon_from_preset(preset:WeaponPreset) -> BaseWeapon:
	var weapon:BaseWeapon = base_weapon_scene.instantiate()
	
	weapon.icon = preset.icon
	weapon.damage_modifier = preset.damage_modifier
	weapon.spread = preset.base_spread
	weapon.cooldown_time = preset.base_cooldown_time
	weapon.projectiles_per_shot = preset.base_projectiles_per_shot
	weapon.scene_projectile = preset.projectile_scene
	
	return weapon


func confirm_selection() -> void:
	var preset:WeaponPreset = weapon_preset_list[selection_index]
	var weapon:BaseWeapon = get_weapon_from_preset(preset)
	
	if not weapon:
		push_error("Could not confirm Weapon Preset selection")
		return
	
	weapon_confirmed.emit(weapon)
