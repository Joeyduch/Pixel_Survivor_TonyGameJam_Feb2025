class_name WeaponSet extends Node2D

signal weapon_given(new_weapon:BaseWeapon, all_weapons:Array[BaseWeapon])

@export var is_active:bool = true

@onready var entity_detection_hitbox:Area2D = $EntityDetectionHitbox

var target_position:Vector2 = Vector2(0,0)


func _ready() -> void:
	entity_detection_hitbox.connect("body_entered", Callable(_on_entity_detection_hitbox_body_entered))



func fire_weapon(weapon:BaseWeapon) -> void:
	if not is_active: return
	update_target_position()
	if target_position == Vector2(0,0): return 
	
	weapon.call_deferred("fire", global_position.direction_to(target_position))


# get-set entity detection hitbox's radius
func get_entity_detection_radius() -> int:
	if entity_detection_hitbox:
		var collision_shape:CollisionShape2D = entity_detection_hitbox.get_node("CollisionShape2D")
		var shape:CircleShape2D = collision_shape.shape
		return int(shape.radius)
	else:
		return 0

func set_entity_detection_radius(radius:int) -> void:
	if entity_detection_hitbox:
		var collision_shape:CollisionShape2D = entity_detection_hitbox.get_node("CollisionShape2D")
		var shape:CircleShape2D = collision_shape.shape
		shape.radius = radius


func is_other_entity(node:Node2D) -> bool: # make sure the node is not this entity holder
	return node is Entity and node != get_entity_holder() 


func get_nearby_entities(exclude_same_team:bool=false) -> Array[Entity]:
	var entities:Array[Entity] = []
	var overlapping_bodies:Array[Node2D] = entity_detection_hitbox.get_overlapping_bodies()
	for body:Node2D in overlapping_bodies:
		if not is_other_entity(body): continue
		if exclude_same_team and body.team == get_entity_holder().team: continue
		entities.append(body)
	return entities


func update_target_position() -> void:
	var lowest_distance:float = -1
	var new_position:Vector2 = Vector2(0,0)
	
	var nearby_entities:Array[Entity] = get_nearby_entities(true) # excluding entities from same team
	for entity:Entity in nearby_entities:
		var distance_to_entity:float = global_position.distance_to(entity.global_position)
		if lowest_distance<0 or distance_to_entity < lowest_distance:
			lowest_distance = distance_to_entity
			new_position = entity.global_position
	target_position = new_position



# returns either the entity holding the weapon (has to be related in the sceneTree (entity parent to weapon)) or null if not found
func get_entity_holder() -> Entity:
	var rootNode:Node = get_tree().get_root()
	var currentNode:Node = get_parent()
	while currentNode != rootNode:
		if currentNode is Entity:
			return currentNode
		currentNode = currentNode.get_parent()
	
	return null


# returns all weapon children
func get_weapons() -> Array[BaseWeapon]:
	var weapons:Array[BaseWeapon] = []
	for child:Node in get_children():
		if child is BaseWeapon:
			weapons.append(child)
	return weapons


func give_weapon(weapon:BaseWeapon) -> void:
	add_child(weapon)
	
	var weapon_list:Array[BaseWeapon] = []
	for child:Node in get_children():
		if child is BaseWeapon:
			weapon_list.append(child)
	
	weapon_given.emit(weapon, weapon_list)



#
#	SIGNALS
#

func _on_base_weapon_fire_ready(ready_weapon:BaseWeapon) -> void:
	if ready_weapon.is_auto_fire:
		fire_weapon(ready_weapon)


func _on_entity_detection_hitbox_body_entered(body:Node2D) -> void:
	if not is_other_entity(body): return
	
	for weapon:Node in get_children():
		if not weapon is BaseWeapon: continue
		fire_weapon(weapon)
