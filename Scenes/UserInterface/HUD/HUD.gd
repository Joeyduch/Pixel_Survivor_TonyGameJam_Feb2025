class_name UIHUD extends Control

var popup_scene:PackedScene = preload("res://Scenes/UserInterface/UIComponents/UIPopup/UIPopup.tscn")

@onready var exp_bar:UIBar = $ExperienceContainer/ExpBar
@onready var level_label:Label = $ExperienceContainer/LevelLabel

@onready var weapons_list:UIWeaponsList = $UIWeaponsList

@onready var popups_container:Control = $PopupsContainer



func _ready() -> void:
	PlayerData.connect("experience_gained", Callable(_player_data_experience_gained))
	PlayerData.connect("leveled_up", Callable(_player_data_leveled_up))
	setup_exp_bar()
	setup_level_label()



#	--------------------
#	METHODS
#	--------------------

# xp / levels
func setup_exp_bar() -> void:
	exp_bar.maximum = PlayerData.experience_for_level_up
	exp_bar.set_value(PlayerData.experience)

func setup_level_label() -> void:
	level_label.text = "LEVEL: " + str(PlayerData.level)


# popups
func create_popup(title:String, description:String, icon:Texture=null) -> UIPopup:
	var popup:UIPopup = popup_scene.instantiate()
	popup.title = title
	popup.description = description
	if icon:
		popup.icon = icon
	popups_container.add_child(popup)
	
	return popup


# weapons list
func update_weapons_list(weapons:Array[BaseWeapon]) -> void:
	if not weapons_list: return
	weapons_list.update_list(weapons)



#	--------------------
#	SIGNALS
#	--------------------

# PlayerData experience + level
func _player_data_experience_gained(_gained:int, new_exp:int) -> void:
	exp_bar.set_value(new_exp)

func _player_data_leveled_up(new_level:int, exp_to_level_up:int) -> void:
	exp_bar.maximum = exp_to_level_up
	level_label.text = "LEVEL: " + str(new_level)
