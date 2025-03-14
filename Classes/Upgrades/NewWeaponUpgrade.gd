class_name NewWeaponUpgrade extends BaseUpgrade

@export var base_weapon_scene:PackedScene = preload("res://Scenes/Components/Weapons/BaseWeapon/BaseWeapon.tscn")


func apply(receiver:Entity) -> void:
	super(receiver)
	
	var weapon_name:String = "NO WEAPON NAME"
	if base_weapon_scene:
		var weapon_node:BaseWeapon = base_weapon_scene.instantiate()
		weapon_name = weapon_node.weapon_name
		receiver.weapon_set.add_child(weapon_node)
	
	print("%s RECEIVED A NEW WEAPON NAMED %s" % [receiver.name, weapon_name])
