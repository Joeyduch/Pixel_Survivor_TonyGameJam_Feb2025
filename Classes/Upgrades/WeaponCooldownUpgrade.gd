class_name WeaponCooldownUpgrade extends WeaponBaseUpgrade

@export var time_scale:float = 1.0



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.cooldown_time *= time_scale
	
	print("SCALED THE COOLDOWN OF ONE OF %s'S WEAPONS BY %s, NOW AT %s" % [
		receiver.name, time_scale, chosen_weapon.cooldown_time
	])
