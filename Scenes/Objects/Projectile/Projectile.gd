class_name Projectile extends Area2D

@export var base_health:int = 1
@export var speed:int = 64

@onready var life:Life = $Life
@onready var on_screen_notifier:VisibleOnScreenNotifier2D = $OnScreenNotifier
@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var lifetime_timer:Timer = $Lifetime

var damage:int = 1 # changed by BaseWeapon when creating new projectile

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



func _body_entered(body:Node2D) -> void:
	if body == creator or not body is Entity: return
	var entity:Entity = body
	if team == entity.team: return
	
	entity.life.hurt(damage)
	life.hurt(1)


func _on_screen_notifier_screen_exited() -> void:
	queue_free()


func _life_died() -> void:
	queue_free()


func _lifetime_timer_timeout() -> void:
	queue_free()
