class_name Entity extends CharacterBody2D

@export var team:int = 0: set = set_team
@export var exp_value:int = 0
@export var thorn_damage:int = 0 # physical contact damage to other teams
@export var blood_color:Color = Color(172.0/255, 49.0/255, 49.0/255) # a red from the color palette

@onready var physics_collision:CollisionShape2D = $PhysicsCollision
@onready var weapon_set:WeaponSet = $WeaponSet
@onready var character_controller:CharacterController = $CharacterController
@onready var life:Life = $Life
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var enemy_detector:EnemyDetector = $EnemyDetector
@onready var health_bar:UISmallBar = $HealthBar
@onready var hit_pitched_audio:AudioStreamPitched2D = $HitPitchedAudio
@onready var death_pitched_audio:AudioStreamPitched2D = $DeathPitchedAudio



func _ready() -> void:
	health_bar.maximum = life.max_health
	health_bar.set_value(life.get_health())
	health_bar.set_visible(life.health < life.max_health)
	set_team(team)
	
	# signals
	life.connect("health_changed", _on_life_health_changed)
	life.connect("max_health_changed", _on_life_max_health_changed)
	life.connect("died", _on_life_died)


func _process(_delta: float) -> void:
	update_sprite()



func set_team(new_value:int) -> void:
	team = new_value
	if enemy_detector:
		enemy_detector.team = new_value


func get_main() -> Main:
	var root:Window = get_tree().get_root()
	var main:Main = root.get_node("Main")
	
	if main is Main:
		return main
	else:
		return null


func get_world() -> World:
	var main:Main = get_main()
	if not main: return null
	var world:World = main.get_node("World")
	
	if world is World:
		return world
	else:
		return null


func update_sprite() -> void:
	if not sprite or not character_controller: return
	var direction:Vector2 = character_controller.direction
	# sprite flip
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	# sprite animation
	if direction.x!=0 or direction.y!=0:
		sprite.play()
	else:
		sprite.stop()


func hurt(damage_amount:int) -> void:
	if damage_amount > 0:
		life.hurt(damage_amount)
		
		animation_player.stop()
		animation_player.play("Hurt")
		
		get_world().spawn_blood_particles(position, blood_color)
		
		hit_pitched_audio.play_random_pitched(0.3)


func die() -> void:
	death_pitched_audio.connect("finished", _on_death_pitched_audio_finished)
	death_pitched_audio.play_random_pitched(0.3)



# signals

func _on_life_health_changed(new_health:int) -> void:
	health_bar.set_value(new_health)
	health_bar.set_visible(new_health < life.max_health)

func _on_life_max_health_changed(new_max:int) -> void:
	health_bar.set_maximum(new_max)


func _on_life_died() -> void:
	die()


func _on_death_pitched_audio_finished() -> void:
	pass
