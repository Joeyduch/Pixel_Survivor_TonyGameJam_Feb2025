class_name World extends Node2D

var scenes_enemies:Array[PackedScene] = [
	preload("res://Scenes/Objects/Entity/Enemy/Enemy.tscn"),
	preload("res://Scenes/Objects/Entity/Enemy/Slime/EnemySlime.tscn"),
	preload("res://Scenes/Objects/Entity/Enemy/Skull/EnemySkull.tscn"),
	preload("res://Scenes/Objects/Entity/Enemy/Bomby/EnemyBomby.tscn"),
]
var scene_exp_drop:PackedScene = preload("res://Scenes/Objects/LootDrop/ExpDrop/ExpDrop.tscn")
var scene_lootbox:PackedScene = preload("res://Scenes/Objects/LootDrop/LootBox/LootBox.tscn")

## this adds (or substracts) to the base enemy health. Goes up every level up
var enemy_health_modifier:int = 0

@export var enemy_spawn_timer:Timer = null
@export var lootbox_spawn_timer:Timer = null
@export var player:Entity = null
@export var max_enemy_spawned:int = 16

@onready var loot_parent:Node = $Loot
@onready var enemies_parent:Node = $Entities/Enemies
@onready var projectile_parent:Node = $Projectiles



func _ready() -> void:
	if enemy_spawn_timer:
		enemy_spawn_timer.connect("timeout", _on_enemy_spawn_timer_timeout)
	if lootbox_spawn_timer:
		lootbox_spawn_timer.connect("timeout", _on_lootbox_spawn_timer_timeout)



func spawn_loot_drop(loot_drop_scene:PackedScene, spawn_position:Vector2) -> LootDrop:
	if not loot_drop_scene or not loot_parent:
		print("ERROR: no scene_exp_drop PackedScene or no loot_parent Node")
		return
	var loot_drop:LootDrop = loot_drop_scene.instantiate()
	loot_drop.position = spawn_position
	loot_parent.call_deferred("add_child", loot_drop)
	
	return loot_drop


func spawn_exp_drop(spawn_position:Vector2, value:int=1) -> void:
	var loot_drop:LootDrop = spawn_loot_drop(scene_exp_drop, spawn_position)
	if loot_drop is not ExpDrop: return
	
	var exp_drop:ExpDrop = loot_drop
	exp_drop.value = value


func spawn_loot_box(spawn_position:Vector2) -> void:
	spawn_loot_drop(scene_lootbox, spawn_position)


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
	var enemy_scene:PackedScene = scenes_enemies[randi_range(0, scenes_enemies.size()-1)]
	var enemy:Entity = enemy_scene.instantiate()
	enemies_parent.add_child(enemy)
	enemy.life.max_health += enemy_health_modifier
	enemy.life.health = enemy.life.max_health
	enemy.position = new_position



# SIGNALS

func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()


func _on_lootbox_spawn_timer_timeout() -> void:
	var spawn_position:Vector2 = Vector2(
		randi_range(0, int(get_viewport().get_visible_rect().size.x)),
		randi_range(0, int(get_viewport().get_visible_rect().size.y)),
	)
	spawn_loot_box(spawn_position)
