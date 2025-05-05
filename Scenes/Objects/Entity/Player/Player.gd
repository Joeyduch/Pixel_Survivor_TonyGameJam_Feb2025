class_name Player extends Entity


func _process(delta:float) -> void:
	super(delta)
	# limit player's position to be inside of the map
	var world:World = get_world()
	if world:
		var map_limit:Vector2i = world.map_size * world.TILE_PIXEL_SIZE
		global_position.x = clamp(global_position.x, 0, map_limit.x)
		global_position.y = clamp(global_position.y, 0, map_limit.y)



func die() -> void:
	super()
	character_controller.is_active = false
	weapon_set.is_active = false
