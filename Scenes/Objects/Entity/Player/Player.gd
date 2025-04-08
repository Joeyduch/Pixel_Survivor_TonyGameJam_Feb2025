class_name Player extends Entity



func die() -> void:
	super()
	character_controller.is_active = false
	weapon_set.is_active = false
