class_name BaseWeapon extends Node2D

signal fire_ready(readied_weapon:BaseWeapon)

@export var weapon_name:String = "Base Weapon"
@export var icon:Texture2D = null
@export var scene_projectile:PackedScene = null
@export var is_auto_fire:bool = true
@export var damage_modifier:int = 0
@export var projectiles_per_shot:int = 1: set = set_projectiles_per_shot
@export var cooldown_time:float = 1: set = set_cooldown_time
@export var spread:float = 15: set = set_spread

@onready var cooldown_timer:Timer = $CooldownTimer
@onready var audio_stream_player:AudioStreamPitched2D = $AudioStreamPitched2D

var is_ready:bool = true



func set_projectiles_per_shot(projectiles_amount:int) -> void:
	projectiles_per_shot = max(1, projectiles_amount)


func set_cooldown_time(time:float) -> void:
	cooldown_time = max(0.05, time)
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown_time


func set_spread(new_spread:float) -> void:
	spread = max(0, new_spread)



func _ready() -> void:
	is_ready = true
	# setup timer
	if cooldown_timer:
		cooldown_timer.wait_time = cooldown_time
	cooldown_timer.connect("timeout", Callable(_on_cooldown_timer_timeout))
	# setup parent Weapons
	var weapons:WeaponSet = get_parent_weapon_set()
	if weapons and weapons.has_method("_on_base_weapon_fire_ready"):
		connect("fire_ready", Callable(weapons._on_base_weapon_fire_ready))



func fire(direction:Vector2, parent_node:Node=null) -> void:
	if not is_ready: return
	# set vars and timer when firing
	is_ready = false
	cooldown_timer.start()
	# create projectile
	for shot_index:int in range(projectiles_per_shot):
		var projectile:Projectile = scene_projectile.instantiate()
		var parent_entity:Entity = get_parent_weapon_set().get_entity_holder()
		projectile.creator = parent_entity
		projectile.team = parent_entity.team
		projectile.base_damage += damage_modifier
		# set direction (with spread)
		var angle_offset:float = randf_range(-spread/2, spread/2)
		if projectiles_per_shot > 1:
			angle_offset = -spread/2 + spread/(projectiles_per_shot-1) * shot_index
		var new_angle_direction:float = direction.angle() + deg_to_rad(angle_offset)
		var new_direction:Vector2 = Vector2.from_angle(new_angle_direction)
		projectile.direction = new_direction
		# set parent and position
		var parent:Node = parent_node
		if not parent:
			parent = parent_entity.get_world().projectile_parent
		projectile.position = global_position
		parent.add_child(projectile)
	
	# play audio
	var projectile_instance:Projectile = scene_projectile.instantiate()
	var audio:AudioStream = projectile_instance.audio_shoot
	if audio:
		audio_stream_player.stream = audio
		audio_stream_player.play_random_pitched(0.3)
	projectile_instance.queue_free()


# returns parent WeaponSet if it exists (or else returns null)
func get_parent_weapon_set() -> WeaponSet:
	var rootNode:Node = get_tree().get_root()
	var currentNode:Node = get_parent()
	while currentNode != rootNode:
		if currentNode is WeaponSet:
			return currentNode
		currentNode = currentNode.get_parent()
	
	return null



func _on_cooldown_timer_timeout() -> void:
	is_ready = true
	fire_ready.emit(self)
