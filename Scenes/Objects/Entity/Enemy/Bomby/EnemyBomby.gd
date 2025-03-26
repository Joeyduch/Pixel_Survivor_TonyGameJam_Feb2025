class_name EnemyBomby extends Enemy

@export var explosion_scene:PackedScene = preload("res://Scenes/Objects/Explosion/Explosion.tscn")
@export var explosion_damage:int = 4

func create_explosion(spawn_position:Vector2) -> void:
	var explosion:Explosion = explosion_scene.instantiate()
	explosion.damage = explosion_damage
	explosion.position = spawn_position
	get_parent().add_child(explosion)


func die() -> void:
	super()
	call_deferred_thread_group("create_explosion", position)
