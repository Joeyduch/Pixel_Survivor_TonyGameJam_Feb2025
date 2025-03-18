class_name Main extends Node

signal game_paused(is_paused:bool)

@onready var world:World = $World
@onready var ui:UI = $UI

 

func _ready() -> void:
	# on game pause
	connect("game_paused", ui._main_game_paused)
	# on level up
	PlayerData.connect("leveled_up", _player_data_leveled_up)
	# on upgrade / new weapon menus
	ui.menus.upgrades_menu.connect("upgrade_chosen", _on_upgrades_menu_upgrade_chosen)
	ui.menus.new_weapon_menu.connect("weapon_confirmed", _on_new_weapon_menu_weapon_confirmed)
	
	if world.player:
		# update weapons list
		world.player.weapon_set.connect("weapon_given", _on_player_weapon_given)
		_on_player_weapon_given(null, world.player.weapon_set.get_weapons())
	
	#PlayerData.gain_experience(3) # ***** TEST TEMPORARY TEST *****


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Control_Escape"):
		toggle_pause()



#	------------------
#	METHODS
#	------------------

func toggle_pause() -> void:
	var is_now_paused:bool = !get_tree().paused
	get_tree().set_pause(is_now_paused)
	game_paused.emit(is_now_paused)



#	------------------
#	SIGNALS
#	------------------

# upgrades menu
func _player_data_leveled_up(_new_level:int, _exp_to_level_up:int) -> void:
	toggle_pause()
	ui.menus.set_menu(ui.menus.MENUS.UPGRADES)


func _on_upgrades_menu_upgrade_chosen(upgrade:BaseUpgrade) -> void:
	if not upgrade:
		push_warning("Invalid upgrade argument, toggling pause and returning.")
		toggle_pause()
		return
	
	# apply upgrade to player
	upgrade.apply(world.player)
	# show upgrade HUD popup
	ui.hud.create_popup(upgrade.upgrade_name, upgrade.description, upgrade.upgrade_icon)
	# unpause
	if upgrade is NewWeaponUpgrade:
		ui.menus.set_menu(ui.menus.MENUS.NEWWEAPON)
	else:
		toggle_pause()


# new weapon menu
func _on_new_weapon_menu_weapon_confirmed(weapon:BaseWeapon) -> void:
	var player:Entity = world.player
	if player:
		player.weapon_set.give_weapon(weapon)
	toggle_pause()


# when player receives new weapon
func _on_player_weapon_given(_new_weapon:BaseWeapon, all_weapons:Array[BaseWeapon]) -> void:
	ui.hud.weapons_list.update_list(all_weapons)
