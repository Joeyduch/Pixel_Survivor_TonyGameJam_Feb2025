class_name UIMenus extends Control

signal menu_changed(current_menu_node:MENUS)
signal request_audio_play(audio_name:String)

enum MENUS {NONE, PAUSE, UPGRADES, NEWWEAPON}

@onready var ui:UI = get_parent() as UI
@onready var menu_shade:ColorRect = $MenuShade
@onready var pause_menu:Control = $PauseMenu
@onready var upgrades_menu:UpgradesMenu = $UpgradesMenu
@onready var new_weapon_menu:Control = $NewWeaponMenu

@onready var menus:Dictionary = {
	MENUS.NONE: null,
	MENUS.PAUSE: pause_menu,
	MENUS.UPGRADES: upgrades_menu,
	MENUS.NEWWEAPON: new_weapon_menu,
}

var current_menu:MENUS = MENUS.NONE: set = set_current_menu
var current_menu_node:Control = null



func _ready() -> void:
	# for every menus
	for child:Control in get_children():
		child.set_visible(false)
	
	set_current_menu(MENUS.NONE)


func _input(event:InputEvent) -> void:
	if event.is_action_pressed("Control_Right"):
		if current_menu == MENUS.UPGRADES:
			request_audio_play.emit("menu_tick")
			upgrades_menu.select_next()
		elif current_menu == MENUS.NEWWEAPON:
			request_audio_play.emit("menu_tick")
			new_weapon_menu.select_next()
	
	elif event.is_action_pressed("Control_Left"):
		if current_menu == MENUS.UPGRADES:
			request_audio_play.emit("menu_tick")
			upgrades_menu.select_previous()
		elif current_menu == MENUS.NEWWEAPON:
			request_audio_play.emit("menu_tick")
			new_weapon_menu.select_previous()
	
	elif event.is_action_pressed("Control_Up"):
		if current_menu == MENUS.NEWWEAPON:
			request_audio_play.emit("menu_tick")
			new_weapon_menu.jump_next()
	
	elif event.is_action_pressed("Control_Down"):
		if current_menu == MENUS.NEWWEAPON:
			request_audio_play.emit("menu_tick")
			new_weapon_menu.jump_previous()
	
	elif event.is_action_pressed("Control_A"):
		if current_menu == MENUS.UPGRADES:
			request_audio_play.emit("menu_select")
			upgrades_menu.choose_upgrade()
		elif current_menu == MENUS.NEWWEAPON:
			request_audio_play.emit("menu_select")
			new_weapon_menu.confirm_selection()
	
	elif event.is_action_pressed("Control_B"):
		if current_menu == MENUS.PAUSE:
			ui.main.quit_to_menu()



#	--------------------
#	METHODS
#	--------------------

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

func set_menu(menu:MENUS) -> void:
	set_current_menu(menu)


func is_in_menu() -> bool:
	return current_menu_node != menus[MENUS.NONE]



#	--------------------
#	SIGNALS
#	--------------------

#func _on_main_menu_asked(menu_enum:MENUS) -> void:
	#set_current_menu(menu_enum)
