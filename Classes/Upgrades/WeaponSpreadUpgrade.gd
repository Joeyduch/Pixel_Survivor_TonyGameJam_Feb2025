class_name WeaponSpreadUpgrade extends WeaponBaseUpgrade

@export var spread_scale:float = 1.0


func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.spread *= spread_scale
	
	upgrade_icon = chosen_weapon.icon
	
	print("%s SCALED THE SPREAD OF WEAPON %s BY %s, NOW AT %s" % [
		receiver.name, chosen_weapon.weapon_name, spread_scale, chosen_weapon.spread
	])
