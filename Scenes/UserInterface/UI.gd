class_name UI extends Control

@onready var hud:UIHUD = $HUD
@onready var menus:UIMenus = $Menus



func _ready() -> void:
	z_index = 10



func _main_game_paused(is_paused:bool) -> void:
	if is_paused:
		menus.set_menu(menus.MENUS.PAUSE)
	else:
		menus.set_menu(menus.MENUS.NONE)
