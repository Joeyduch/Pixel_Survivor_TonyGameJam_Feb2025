class_name NewWeaponUpgrade extends BaseUpgrade

@export var base_weapon_scene:PackedScene = preload("res://Scenes/Components/Weapons/BaseWeapon/BaseWeapon.tscn")


func apply(receiver:Entity) -> void:
	super(receiver)
	
	# The actual use of this upgrade is inside of the Main's
	# on-upgrade-chosen signal where the new weapon menu is opened
	
	# debug print
	print("%s RECEIVED A NEW WEAPON" % [receiver.name])
