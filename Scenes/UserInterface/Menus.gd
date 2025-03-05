class_name UIMenus extends Control

signal menu_changed(current_menu_node:MENUS)

enum MENUS {NONE, PAUSE, UPGRADES}

@onready var menu_shade:ColorRect = $MenuShade
@onready var pause_menu:Control = $PauseMenu
@onready var upgrades_menu:Control = $UpgradesMenu

@onready var menus:Dictionary = {
	MENUS.NONE: null,
	MENUS.PAUSE: pause_menu,
	MENUS.UPGRADES: upgrades_menu
}

var current_menu:MENUS = MENUS.NONE: set = set_current_menu
var current_menu_node:Control = null



func _ready() -> void:
	# for every menus
	for child:Control in get_children():
		if child == menu_shade: continue
		child.set_visible(false)
	
	set_current_menu(MENUS.NONE)


func _input(event:InputEvent) -> void:
	if event.is_action_pressed("Control_Right"):
		if current_menu == MENUS.UPGRADES:
			upgrades_menu.select_next()
	elif event.is_action_pressed("Control_Left"):
		if current_menu == MENUS.UPGRADES:
			upgrades_menu.select_previous()
	elif event.is_action_pressed("Control_A"):
		if current_menu == MENUS.UPGRADES:
			upgrades_menu.choose_upgrade()




func set_current_menu(menu:MENUS) -> void:
	if current_menu_node:
		current_menu_node.set_visible(false)
	
	current_menu = menu
	current_menu_node = menus[menu]
	menu_changed.emit(menu)
	
	if current_menu_node:
		menu_shade.set_visible(true)
		current_menu_node.set_visible(true)
	else:
		menu_shade.set_visible(false)


func is_in_menu() -> bool:
	return current_menu_node != menus[MENUS.NONE]



func _on_main_menu_asked(menu_enum:MENUS) -> void:
	set_current_menu(menu_enum)
