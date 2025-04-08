class_name ProjectileBomb extends Projectile

@export var explosion_scene:PackedScene = preload("res://Scenes/Objects/Explosion/Explosion.tscn")
@export var explosion_range:int = 20
@export var extra_explosion_amount:int = 2



func create_explosion(spawn_position:Vector2, play_audio:bool=true) -> void:
	var explosion:Explosion = explosion_scene.instantiate()
	explosion.position = spawn_position
	explosion.damage = base_damage
	explosion.play_audio = play_audio
	get_parent().add_child(explosion)


# parent method
func destroy() -> void:
	super()
	call_deferred("create_explosion", position, true)
	
	for i:int in range(extra_explosion_amount):
		var position_offset:Vector2 = Vector2(
			randi_range(-explosion_range, explosion_range),
			randi_range(-explosion_range, explosion_range)
		)
		call_deferred("create_explosion", position+position_offset, false)
