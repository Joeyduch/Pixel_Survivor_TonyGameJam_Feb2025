class_name UpgradesList extends Resource

@export var list_thumbnail:Texture2D = null
@export var description:String = "An UpgradesList Description."
@export var upgrades_list:Array[BaseUpgrade] = []
@export var chance_list:Array[float] = []


## returns a 2d array of the format [[value, chance], [value, chance], ...]
func get_full_list() -> Array[Array]:
	var list:Array[Array] = []
	var index:int = 0
	
	for upgrade:BaseUpgrade in upgrades_list:
		var chance:float = 1.0
		if index < chance_list.size():
			chance = chance_list[index]
		
		list.append([upgrade, chance])
		index += 1
	
	return list
