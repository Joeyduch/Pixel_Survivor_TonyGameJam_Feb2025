class_name WeaponDamageUpgrade extends WeaponBaseUpgrade

@export var damage_bonus:int = 1



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if not chosen_weapon: return
	
	chosen_weapon.damage_modifier += damage_bonus
	upgrade_icon = chosen_weapon.icon
	
	print("%s ADDED %s DAMAGE TO WEAPON %s" % [
		receiver.name, damage_bonus, chosen_weapon.weapon_name
	])
