class_name Enemy extends Entity



func die() -> void:
	super()
	if exp_value > 0:
		get_world().spawn_exp_drop(global_position, exp_value)
	
	# turn off collisions + detectors
	physics_collision.set_deferred("disabled", true)
	weapon_set.is_active = false
	character_controller.is_active = false
	enemy_detector.is_active = false
	# hide sprites
	sprite.visible = false
	health_bar.visible = false


func _on_death_pitched_audio_finished() -> void:
	queue_free()
