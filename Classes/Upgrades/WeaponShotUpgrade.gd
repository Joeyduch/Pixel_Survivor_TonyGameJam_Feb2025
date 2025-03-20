class_name WeaponShotUpgrade extends WeaponBaseUpgrade

@export var shot_amount_bonus:int = 1



func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if not chosen_weapon: return
	
	chosen_weapon.projectiles_per_shot += shot_amount_bonus
	upgrade_icon = chosen_weapon.icon
	
	print("%s ADDED %s MORE PROJECTILE PER SHOT FOR WEAPON %s" % [
		receiver.name, shot_amount_bonus, chosen_weapon.weapon_name
	])
