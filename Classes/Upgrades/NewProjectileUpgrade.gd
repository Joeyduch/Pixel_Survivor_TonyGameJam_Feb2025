class_name NewProjectileUpgrade extends WeaponBaseUpgrade

var projectile_scenes:Array[PackedScene] = [
	preload("res://Scenes/Objects/Projectile/ProjectileFire/ProjectileFire.tscn"),
	preload("res://Scenes/Objects/Projectile/ProjectileBomb/ProjectileBomb.tscn"),
	preload("res://Scenes/Objects/Projectile/ProjectileBomb/ProjectileMine/ProjectileMine.tscn"),
]


func apply(receiver:Entity) -> void:
	super(receiver)
	
	var chosen_weapon:BaseWeapon = get_random_weapon(receiver)
	if not chosen_weapon: return
	
	upgrade_icon = chosen_weapon.icon
	
	var new_projectile:PackedScene = projectile_scenes[randi_range(0, projectile_scenes.size()-1)]
	chosen_weapon.scene_projectile = new_projectile
	
	print("%s got a new projectile on a random weapon." % [receiver.name])
