class_name Projectile extends Area2D

@export var base_health:int = 1
@export var speed:int = 128
@export var is_projectile_damaging:bool = true # can be turned off for special projectiles like bombs
@export var base_damage:int = 1
@export var audio_shoot:AudioStream = preload("res://Assets/Sounds/ShootProjectile.wav")

@onready var life:Life = $Life
@onready var on_screen_notifier:VisibleOnScreenNotifier2D = $OnScreenNotifier
@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var lifetime_timer:Timer = $Lifetime

var creator:Entity = null
var team:int = -1
var direction:Vector2 = Vector2(0,0)



func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	life.connect("died", Callable(_life_died))
	on_screen_notifier.connect("screen_exited", Callable(_on_screen_notifier_screen_exited))
	lifetime_timer.connect("timeout", Callable(_lifetime_timer_timeout))
	
	life.set_max_health(base_health)
	life.set_health(base_health)
	animated_sprite.play()


func _physics_process(delta: float) -> void:
	var movement_vector:Vector2 = (direction.normalized() * speed) * delta
	position += movement_vector



#	--------------------
#	METHODS
#	--------------------

func destroy() -> void:
	queue_free()



#	--------------------
#	SIGNALS
#	--------------------

func _body_entered(body:Node2D) -> void:
	if body == creator or not body is Entity: return
	var entity:Entity = body
	if team == entity.team: return
	
	if is_projectile_damaging:
		entity.hurt(base_damage)
	life.hurt(1)


func _on_screen_notifier_screen_exited() -> void:
	destroy()


func _life_died() -> void:
	destroy()


func _lifetime_timer_timeout() -> void:
	destroy()
