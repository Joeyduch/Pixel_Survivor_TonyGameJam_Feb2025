class_name LootBox extends LootDrop

@export var loot_upgrades_list:UpgradesList = preload("res://Resources/Upgrades/UpgradesLists/LootBoxUpgradesList.tres")

func collect(player_body:Entity) -> void:
	super(player_body)
	
	var randomSelector:RandomSelector = RandomSelector.new(loot_upgrades_list.get_full_list())
	var upgrade:BaseUpgrade = randomSelector.roll_item()
	
	player_body.get_main().give_upgrade(upgrade)
