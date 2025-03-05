class_name AIController extends Node

@export var character_controller:CharacterController = null
@export var target_follower:TargetFollower = null

var entity:Entity = null


func _ready() -> void:
	# setup controlling entity
	var parent:Node = get_parent()
	if parent is Entity:
		entity = parent
	
	# setup target to player
	var world:World = entity.get_world()
	if world is World and target_follower:
		target_follower.target = world.player


func _process(delta: float) -> void:
	if not entity is Entity: return
	
	# move towards player
	character_controller.set_direction(target_follower.get_direction_to_target(entity.position))
	character_controller.move(delta)
