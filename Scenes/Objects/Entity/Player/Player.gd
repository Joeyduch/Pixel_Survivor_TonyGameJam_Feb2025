class_name Player extends Entity



func die() -> void:
	character_controller.is_active = false
	weapon_set.is_active = false
