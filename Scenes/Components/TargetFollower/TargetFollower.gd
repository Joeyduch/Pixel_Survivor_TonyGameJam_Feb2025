class_name TargetFollower extends Node

@export var target:Node2D = null


func get_direction_to_target(fromPosition:Vector2) -> Vector2:
	if not target: return Vector2(0, 0)
	return fromPosition.direction_to(target.position)
