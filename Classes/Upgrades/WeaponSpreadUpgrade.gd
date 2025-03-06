class_name WeaponSpreadUpgrade extends WeaponBaseUpgrade

@export var spread_scale:float = 1.0


func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.spread *= spread_scale
	
	print("SCALED THE SPREAD OF ONE OF %s'S WEAPONS BY %s, NOW AT %s" % [
		receiver.name, spread_scale, chosen_weapon.spread
	])
