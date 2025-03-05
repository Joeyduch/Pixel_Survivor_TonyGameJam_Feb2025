class_name UIHUD extends Control


@onready var exp_bar:UIBar = $ExperienceContainer/ExpBar
@onready var level_label:Label = $ExperienceContainer/LevelLabel



func _ready() -> void:
	PlayerData.connect("experience_gained", Callable(_player_data_experience_gained))
	PlayerData.connect("leveled_up", Callable(_player_data_leveled_up))
	setup_exp_bar()
	setup_level_label()



func setup_exp_bar() -> void:
	exp_bar.maximum = PlayerData.experience_for_level_up
	exp_bar.set_value(PlayerData.experience)

func setup_level_label() -> void:
	level_label.text = "LEVEL: " + str(PlayerData.level)



#
#	SIGNALS
#

# PlayerData experience + level
func _player_data_experience_gained(_gained:int, new_exp:int) -> void:
	exp_bar.set_value(new_exp)

func _player_data_leveled_up(new_level:int, exp_to_level_up:int) -> void:
	exp_bar.maximum = exp_to_level_up
	level_label.text = "LEVEL: " + str(new_level)
