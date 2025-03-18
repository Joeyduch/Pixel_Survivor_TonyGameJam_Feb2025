class_name Entity extends CharacterBody2D

@export var team:int = 0: set = set_team
@export var exp_value:int = 0
@export var thorn_damage:int = 0 # physical contact damage to other teams

@onready var weapon_set:WeaponSet = $WeaponSet
@onready var character_controller:CharacterController = $CharacterController
@onready var life:Life = $Life
@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_detector:EnemyDetector = $EnemyDetector
@onready var health_bar:UISmallBar = $HealthBar



func _ready() -> void:
	health_bar.maximum = life.max_health
	health_bar.set_value(life.get_health())
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
	if not main: return
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



# signals

func _on_life_health_changed(new_health:int) -> void:
	health_bar.set_value(new_health)

func _on_life_max_health_changed(new_max:int) -> void:
	health_bar.set_maximum(new_max)


func _on_life_died() -> void:
	if self == get_world().player:
		character_controller.is_active = false
		weapon_set.is_active = false
	else:
		if exp_value > 0:
			get_world().spawn_exp_drop(global_position, exp_value)
		queue_free()
