class_name World extends Node2D

## size of a tile in pixels (they are designed at 8 pixels but exported at 16)
const TILE_PIXEL_SIZE:int = 16

# scenes
const scenes_enemies:Dictionary[String, PackedScene] = {
	"zombie": preload("res://Scenes/Objects/Entity/Enemy/Enemy.tscn"),
	"slime": preload("res://Scenes/Objects/Entity/Enemy/Slime/EnemySlime.tscn"),
	"skull": preload("res://Scenes/Objects/Entity/Enemy/Skull/EnemySkull.tscn"),
	"bomby": preload("res://Scenes/Objects/Entity/Enemy/Bomby/EnemyBomby.tscn"),
	"gunner": preload("res://Scenes/Objects/Entity/Enemy/Gunner/EnemyGunner.tscn"),
	"slimeboss": preload("res://Scenes/Objects/Entity/Enemy/Slime/SlimeBoss/EnemySlimeBoss.tscn"),
}
const scene_exp_drop:PackedScene = preload("res://Scenes/Objects/LootDrop/ExpDrop/ExpDrop.tscn")
const scene_lootbox:PackedScene = preload("res://Scenes/Objects/LootDrop/LootBox/LootBox.tscn")

## a dictionary of all the Enemy types that spawns at Level <KEY> {LevelSpawned:int, Array[PackedScene]}
const enemy_levels_map:Dictionary[int, Array] = {
	0: [
		scenes_enemies["zombie"],
	],
	3: [
		scenes_enemies["slime"],
	],
	5: [
		scenes_enemies["skull"],
	],
	7: [
		scenes_enemies["bomby"],
	],
	10: [
		scenes_enemies["gunner"],
	],
}

## a dictionary of all the GPUParticles2D or OneShotParticles scenes,
## in the format {ParticleNameString : ParticlePackedScene}
var scenes_particles:Dictionary[String, PackedScene] = {
	"blood": preload("res://Scenes/Objects/Particle/OneShotParticles/BloodParticles/BloodParticles.tscn"),
}

## this adds (or substracts) to the base enemy health. Goes up every level up
var enemy_health_modifier:int = 0

# event variables
const HORDE_SIZE_MINIMUM:int = 4
const HORDE_SIZE_MAXIMUM:int = 16
const BOSS_SPAWN_LEVEL:int = 12

@export_category("Timers")
@export var enemy_spawn_timer:Timer = null
@export var lootbox_spawn_timer:Timer = null
@export var event_timer:Timer = null
@export_category("World")
@export var player:Entity = null 
@export var max_enemy_spawned:int = 32

@onready var game_camera:GameCamera = $GameCamera
@onready var background_tilemap:AutoTileMap = $Background/AutoTileMap
@onready var loot_parent:Node = $Loot
@onready var enemies_parent:Node = $Entities/Enemies
@onready var projectile_parent:Node = $Projectiles
@onready var particles_parent:Node = $Particles

var map_size:Vector2i = Vector2i(8,8) # changed at _ready



func _ready() -> void:
	print("WORLD READY")
	# connecting signals
	if enemy_spawn_timer:
		enemy_spawn_timer.connect("timeout", _on_enemy_spawn_timer_timeout)
	if lootbox_spawn_timer:
		lootbox_spawn_timer.connect("timeout", _on_lootbox_spawn_timer_timeout)
	if event_timer:
		event_timer.connect("timeout", _on_event_timer_timeout)
	
	# setup camera & player
	map_size = GameData.settings["map_size"]
	if player:
		# player spawn position
		player.position = Vector2(
			float(map_size.x) / 2 * TILE_PIXEL_SIZE,
			float(map_size.y) / 2 * TILE_PIXEL_SIZE
		)
		# camera target
		game_camera.target_node = player
		# camera limits
		game_camera.limit_right = map_size.x * TILE_PIXEL_SIZE
		game_camera.limit_bottom = map_size.y * TILE_PIXEL_SIZE
	
	# generate world
	background_tilemap.map_size = map_size
	background_tilemap.generate()



#	----------
#	METHODS
#	----------

## returns a random position outside the viewport with an added outside margin,
## useful for spawning enemies right outside the viewport
func get_random_position_outside_viewport(outside_margin_size:int=0) -> Vector2:
	var new_position:Vector2 = Vector2(0,0)
	var is_spawning_horizontally:bool = randf() <= 0.5
	var center_screen_position:Vector2 = game_camera.get_screen_center_position()
	var viewport_size:Vector2 = get_viewport_rect().size
	
	if is_spawning_horizontally:
		var min_y_location:int = int(center_screen_position.y - viewport_size.y/2) # top
		var max_y_location:int = min_y_location + int(viewport_size.y) # bottom
		var y_location:int = randi_range(min_y_location, max_y_location)
		
		var x_location:int = int(center_screen_position.x - viewport_size.x/2) - outside_margin_size #left
		var is_spawning_right:bool = randf() <= 0.5
		if is_spawning_right:
			x_location = int(center_screen_position.x + viewport_size.x/2) + outside_margin_size # right
		
		new_position = Vector2(x_location, y_location)
	else:
		var min_x_location:int = int(center_screen_position.x - viewport_size.x/2) # left
		var max_x_location:int = min_x_location + int(viewport_size.x) # right
		var x_location:int = randi_range(min_x_location, max_x_location)
		
		var y_location:int = int(center_screen_position.y - viewport_size.y/2) - outside_margin_size # top
		var is_spawning_down:bool = randf() <= 0.5
		if is_spawning_down:
			y_location = int(center_screen_position.y + viewport_size.y/2) + outside_margin_size
		
		new_position = Vector2(x_location, y_location)
	
	return new_position


# spawn methods
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


func choose_random_enemy_scene() -> PackedScene:
	# choose enemy type
	var enemy_candidates:Array[PackedScene] = []
	for enemy_level:int in enemy_levels_map:
		if enemy_level > PlayerData.level: continue
		var enemy_scenes:Array[Variant] = enemy_levels_map[enemy_level]
		enemy_candidates.append_array(enemy_scenes)
	if enemy_candidates.size() <= 0: return null
	# return enemy scene
	return enemy_candidates[randi_range(0, enemy_candidates.size()-1)]

func spawn_enemy(enemy_scene:PackedScene, spawn_position:Vector2, ignore_enemy_limit:bool=false) -> void:
	# spawn limitations
	if not enemies_parent: return
	
	if not ignore_enemy_limit:
		if enemies_parent.get_children().size() >= max_enemy_spawned: return
	
	# create + setup new enemy
	var enemy:Entity = enemy_scene.instantiate()
	enemies_parent.add_child(enemy)
	enemy.life.max_health += enemy_health_modifier
	enemy.life.health = enemy.life.max_health
	enemy.position = spawn_position

func spawn_enemy_random(spawn_position:Vector2, ignore_enemy_limit:bool=false) -> void:
	var random_enemy:PackedScene = choose_random_enemy_scene()
	if random_enemy:
		spawn_enemy(random_enemy, spawn_position, ignore_enemy_limit)


func spawn_particles(particles_name:String, spawn_position:Vector2) -> GPUParticles2D:
	if not scenes_particles.has(particles_name):
		push_error("particles name %s is invalid / not found." % [particles_name])
		return
	
	var particles_scene:PackedScene = scenes_particles[particles_name]
	var particles:GPUParticles2D = particles_scene.instantiate()
	particles_parent.add_child(particles)
	particles.position = spawn_position
	
	return particles


func spawn_blood_particles(spawn_position:Vector2, color:Variant=null) -> void:
	var blood_particles:GPUParticles2D = spawn_particles("blood", spawn_position)
	if blood_particles is BloodParticles and color is Color:
		blood_particles.set_blood_color(color)


# event methods
func trigger_event_horde() -> void:
	var horde_size:int = clamp(PlayerData.level, HORDE_SIZE_MINIMUM, HORDE_SIZE_MAXIMUM)
	for i:int in range(horde_size):
		spawn_enemy_random(get_random_position_outside_viewport(32))
	print("HORDE EVENT TRIGGERED (SIZE:%s)" % [horde_size])

func trigger_event_boss() -> void:
	var boss_scene:PackedScene = scenes_enemies["slimeboss"]
	if boss_scene:
		spawn_enemy(boss_scene, get_random_position_outside_viewport(32), true)
	print("BOSS EVENT TRIGGERED")



#	----------
#	SIGNALS
#	----------

func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy_random(get_random_position_outside_viewport(32))


func _on_lootbox_spawn_timer_timeout() -> void:
	const MARGIN_PIXEL_SIZE:int = 16
	var viewport_size:Vector2i = get_viewport().get_visible_rect().size
	var spawn_position:Vector2 = Vector2(
		randi_range(
			int(game_camera.position.x)+MARGIN_PIXEL_SIZE,
			int(game_camera.position.x + viewport_size.x)-MARGIN_PIXEL_SIZE
		),
		randi_range(
			int(game_camera.position.y)+MARGIN_PIXEL_SIZE,
			int(game_camera.position.y + viewport_size.y)-MARGIN_PIXEL_SIZE
		),
	)
	spawn_loot_box(spawn_position)


func _on_event_timer_timeout() -> void:
	if PlayerData.level >= BOSS_SPAWN_LEVEL:
		if randf() <= 0.5:
			trigger_event_boss()
		else:
			trigger_event_horde()
	else:
		trigger_event_horde()
