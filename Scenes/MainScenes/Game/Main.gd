class_name Main extends Node

signal game_paused(is_paused:bool)

var scene_main_menu:PackedScene = load("res://Scenes/MainScenes/MainMenu/MainMenu.tscn")

@onready var world:World = $World
@onready var ui:UI = $UI

@onready var music_audio:AudioStreamPlayer = $MusicAudio
var music_playback_position:float = 0

## list of all UpgradesList and their level plateau, in the format [[UpgradesList, level_plateau:int], ...]
@onready var upgrades_list_plateau:Array[Array] = [
	[preload("res://Resources/Upgrades/UpgradesLists/LifeUpgradesList.tres"), 1],
	[preload("res://Resources/Upgrades/UpgradesLists/CharacterUpgradesList.tres"), 2],
	[preload("res://Resources/Upgrades/UpgradesLists/WeaponUpgradesList.tres"), 3],
	[preload("res://Resources/Upgrades/UpgradesLists/NewWeaponUpgradesList.tres"), 4],
]
var lootbox_upgrades_list:UpgradesList = preload("res://Resources/Upgrades/UpgradesLists/BoxUpgradesList.tres") as UpgradesList
var lootbox_upgrades_list_chance:float = 0.2



func _ready() -> void:
	print("MAIN READY")
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
	#world.trigger_event_boss() # ***** TEST TEMPORARY TEST *****


func _input(event: InputEvent) -> void:
	# pause game
	if event.is_action_pressed("Control_Escape"):
		if ui.menus.current_menu == ui.menus.MENUS.NONE or ui.menus.current_menu == ui.menus.MENUS.PAUSE:
			toggle_pause()
	
	# reload on player death
	if (event.is_action_pressed("Control_A") or event.is_action_pressed("Control_B")) and world.player:
		if world.player.life.is_dead:
			reload_scene()



#	------------------
#	METHODS
#	------------------

func reload_scene() -> void:
	PlayerData.reset()
	get_tree().reload_current_scene()


func quit_to_menu() -> void:
	toggle_pause()
	ui.hud.color_overlay.fade_in()
	music_audio.stop()
	await ui.hud.color_overlay.animation_player.animation_finished
	PlayerData.reset()
	get_tree().change_scene_to_packed(scene_main_menu)


func toggle_pause() -> void:
	var is_now_paused:bool = !get_tree().paused
	get_tree().set_pause(is_now_paused)
	game_paused.emit(is_now_paused)
	
	#music
	if is_now_paused:
		music_playback_position = music_audio.get_playback_position()
		music_audio.stop()
	else:
		music_audio.play(music_playback_position)


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
func _player_data_leveled_up(new_level:int, _exp_to_level_up:int) -> void:
	toggle_pause()
	# set new UpgradeLists depending on level plateau
	var upgrades_lists_array:Array[UpgradesList] = []
	# - random lootbox upgrades
	var lootbox_upgrades:UpgradesList = lootbox_upgrades_list
	if lootbox_upgrades:
		if new_level == 1 or randf() <= lootbox_upgrades_list_chance:
			upgrades_lists_array.append(lootbox_upgrades)
	# - upgrades list plateau
	for upgrade_plateau:Array[Variant] in upgrades_list_plateau:
		var upgrade_list:UpgradesList = upgrade_plateau[0]
		var plateau:int = upgrade_plateau[1]
		if new_level % plateau == 0:
			upgrades_lists_array.append(upgrade_list)
	ui.menus.upgrades_menu.set_upgrades_list(upgrades_lists_array)
	# call upgrade menu
	ui.menus.set_menu(ui.menus.MENUS.UPGRADES)
	# play level_up sound
	ui.audio.play_audio("level_up")
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
	music_audio.stop()
