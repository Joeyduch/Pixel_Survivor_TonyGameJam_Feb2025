class_name WeaponShotUpgrade extends WeaponBaseUpgrade

@export var shot_amount_bonus:int = 1



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if chosen_weapon:
		chosen_weapon.projectiles_per_shot += shot_amount_bonus
	
	print("%s ADDED %s MORE PROJECTILE PER SHOT FOR WEAPON %s" % [
		receiver.name, shot_amount_bonus, chosen_weapon.weapon_name
	])
