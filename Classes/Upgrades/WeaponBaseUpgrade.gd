class_name WeaponBaseUpgrade extends BaseUpgrade



func apply(receiver:Entity) -> void:
	super(receiver)



func get_random_weapon(entity:Entity) -> BaseWeapon:
	var weapons:Array[BaseWeapon] = entity.weapon_set.get_weapons()
	if weapons.size() <= 0: return null
	
	var index:int = randi_range(0, weapons.size()-1)
	var chosen_weapon:BaseWeapon = weapons[index]
	
	return chosen_weapon
