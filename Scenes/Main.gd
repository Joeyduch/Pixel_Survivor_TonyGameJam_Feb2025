class_name Main extends Node

signal game_paused(is_paused:bool)

@onready var world:World = $World
@onready var ui:UI = $UI



func _ready() -> void:
	connect("game_paused", Callable(ui._main_game_paused))
	PlayerData.connect("leveled_up", Callable(_player_data_leveled_up))
	ui.ui_menus.upgrades_menu.connect("upgrade_chosen", Callable(_on_upgrades_menu_upgrade_chosen))
	
	PlayerData.gain_experience(3) # ***** TEST TEMPORARY TEST *****


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Control_Escape"):
		toggle_pause()



func toggle_pause() -> void:
	var is_now_paused:bool = !get_tree().paused
	get_tree().set_pause(is_now_paused)
	game_paused.emit(is_now_paused)



func _player_data_leveled_up(_new_level:int, _exp_to_level_up:int) -> void:
	toggle_pause()
	ui.menu_asked.emit(ui.ui_menus.MENUS.UPGRADES)


func _on_upgrades_menu_upgrade_chosen(upgrade:BaseUpgrade) -> void:
	if upgrade:
		upgrade.apply(world.player)
	toggle_pause()
