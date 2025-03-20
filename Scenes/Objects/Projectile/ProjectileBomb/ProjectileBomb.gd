class_name ProjectileBomb extends Projectile

@export var explosion_scene:PackedScene = preload("res://Scenes/Objects/Explosion/Explosion.tscn")



func create_explosion(spawn_position:Vector2) -> void:
	var explosion:Explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	explosion.damage = base_damage
	get_parent().add_child(explosion)


# parent method
func destroy() -> void:
	super()
	call_deferred("create_explosion", position)
