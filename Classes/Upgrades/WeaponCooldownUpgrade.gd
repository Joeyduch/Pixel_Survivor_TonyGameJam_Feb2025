class_name WeaponCooldownUpgrade extends WeaponBaseUpgrade

@export var time_scale:float = 1.0



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if not chosen_weapon: return
	
	chosen_weapon.cooldown_time *= time_scale
	upgrade_icon = chosen_weapon.icon
	
	print("%s SCALED THE COOLDOWN OF WEAPON %s BY %s, NOW AT %s" % [
		receiver.name, chosen_weapon.weapon_name, time_scale, chosen_weapon.cooldown_time
	])
