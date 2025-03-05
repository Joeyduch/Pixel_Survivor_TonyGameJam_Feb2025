class_name UI extends Control

signal menu_asked(menu_enum:int)

@onready var ui_menus:UIMenus = $Menus



func _ready() -> void:
	z_index = 10
	connect("menu_asked", Callable(ui_menus._on_main_menu_asked))



func _main_game_paused(is_paused:bool) -> void:
	if is_paused:
		menu_asked.emit(ui_menus.MENUS.PAUSE)
	else:
		menu_asked.emit(ui_menus.MENUS.NONE)
