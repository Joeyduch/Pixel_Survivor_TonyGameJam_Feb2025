class_name WeaponShotUpgrade extends WeaponBaseUpgrade

@export var shot_amount_bonus:int = 1



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.projectiles_per_shot += shot_amount_bonus
	
	print("ADDED %s MORE PROJECTILE PER SHOT FOR ONE OF %s's RANDOM WEAPON" % [
		shot_amount_bonus, receiver.name
	])
