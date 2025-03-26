class_name Enemy extends Entity



func die() -> void:
	if exp_value > 0:
		get_world().spawn_exp_drop(global_position, exp_value)
	queue_free()
