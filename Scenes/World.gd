class_name World extends Node2D

@export var scene_enemy:PackedScene = null
@export var scene_exp_drop:PackedScene = null
@export var spawn_timer:Timer = null
@export var player:Entity = null
@export var max_enemy_spawned:int = 16

@onready var loot_parent:Node = $Loot
@onready var enemies_parent:Node = $Entities/Enemies
@onready var projectile_parent:Node = $Projectiles



func _ready() -> void:
	if spawn_timer:
		spawn_timer.connect("timeout", Callable(spawn_enemy))



func spawn_exp_drop(spawn_position:Vector2, value:int=1) -> void:
	if not scene_exp_drop or not loot_parent:
		print("ERROR: no scene_exp_drop PackedScene or no loot_parent Node")
		return
	var exp_drop:ExpDrop = scene_exp_drop.instantiate()
	exp_drop.position = spawn_position
	exp_drop.value = value
	loot_parent.call_deferred("add_child", exp_drop)


func spawn_enemy() -> void:
	# get nodes
	var spawn_locations_node:Node = get_node("SpawnLocations")
	if not enemies_parent or not spawn_locations_node: return
	# spawn limitations
	if enemies_parent.get_children().size() >= max_enemy_spawned: return
	# get new position by randomly selection a location
	var spawn_locations:Array[Node] = spawn_locations_node.get_children()
	var index:int = randi_range(0, spawn_locations.size()-1)
	var new_position:Vector2 = spawn_locations[index].position
	# create new enemy
	var enemy:Entity = scene_enemy.instantiate()
	enemy.position = new_position
	enemies_parent.add_child(enemy)
