class_name WeaponDamageUpgrade extends WeaponBaseUpgrade

@export var damage_bonus:int = 1



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.damage += damage_bonus
	
	print("ADDED %s DAMAGE TO ONE OF %s 's WEAPONS" % [damage_bonus, receiver.name])
