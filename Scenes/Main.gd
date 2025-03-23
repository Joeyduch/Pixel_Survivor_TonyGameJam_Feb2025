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
		# death screen
		world.player.life.connect("died", _on_player_life_died)
	
	#PlayerData.gain_experience(3) # ***** TEST TEMPORARY TEST *****


func _input(event: InputEvent) -> void:
	# pause game
	if event.is_action_pressed("Control_Escape"):
		toggle_pause()
	
	# reload on player death
	if (event.is_action_pressed("Control_A") or event.is_action_pressed("Control_B")) and world.player:
		if world.player.life.is_dead:
			PlayerData.reset()
			get_tree().reload_current_scene()



#	------------------
#	METHODS
#	------------------

func toggle_pause() -> void:
	var is_now_paused:bool = !get_tree().paused
	get_tree().set_pause(is_now_paused)
	game_paused.emit(is_now_paused)


func give_upgrade(upgrade:BaseUpgrade) -> void:
	# apply upgrade to player
	upgrade.apply(world.player)
	# show upgrade HUD popup
	ui.hud.create_popup(upgrade.upgrade_name, upgrade.description, upgrade.upgrade_icon)
	# unpause (or go to new weapon menu if upgrade is new weapon
	if upgrade is NewWeaponUpgrade:
		if ui.menus.current_menu == ui.menus.MENUS.NONE:
			toggle_pause()
		ui.menus.set_menu(ui.menus.MENUS.NEWWEAPON)
	elif ui.menus.current_menu != ui.menus.MENUS.NONE:
		toggle_pause()



#	------------------
#	SIGNALS
#	------------------

# upgrades menu
func _player_data_leveled_up(_new_level:int, _exp_to_level_up:int) -> void:
	toggle_pause()
	# call upgrade menu
	ui.menus.set_menu(ui.menus.MENUS.UPGRADES)
	# sets difficulty up
	world.enemy_health_modifier += 1


func _on_upgrades_menu_upgrade_chosen(upgrade:BaseUpgrade) -> void:
	if not upgrade:
		push_warning("Invalid upgrade argument, toggling pause and returning.")
		toggle_pause()
		return
	
	give_upgrade(upgrade)


# new weapon menu
func _on_new_weapon_menu_weapon_confirmed(weapon:BaseWeapon) -> void:
	var player:Entity = world.player
	if player:
		player.weapon_set.give_weapon(weapon)
	toggle_pause()


# when player receives new weapon
func _on_player_weapon_given(_new_weapon:BaseWeapon, all_weapons:Array[BaseWeapon]) -> void:
	ui.hud.weapons_list.update_list(all_weapons)


# when player dies
func _on_player_life_died() -> void:
	ui.hud.color_overlay.fade_in()
	ui.hud.death_screen.set_visible(true)
