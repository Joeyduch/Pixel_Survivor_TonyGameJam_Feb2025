class_name EnemySlimeBoss extends EnemySlime

@export var slimelings_spawn_count:int = 4
@export var slimelings_spawn_offset_range:float = 8

func die() -> void:
	super()
	var slime_scene:PackedScene = get_world().scenes_enemies["slime"]
	for i:int in range(slimelings_spawn_count):
		var spawn_position_offset:Vector2 = Vector2(
			randf_range(-slimelings_spawn_offset_range,slimelings_spawn_offset_range),
			randf_range(-slimelings_spawn_offset_range,slimelings_spawn_offset_range))
		get_world().call_deferred("spawn_enemy", slime_scene, position + spawn_position_offset, true)
	print("BOSS DEAD (EnemySlimeBoss.gd)")
