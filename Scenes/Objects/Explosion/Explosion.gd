class_name Explosion extends Area2D

@export var damage:int = 1 # set by the bomb projectile

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape:CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	connect("body_entered", _on_body_entered)
	animated_sprite.connect("animation_finished", _on_animated_sprite_animation_finished)
	animated_sprite.play()



func _on_body_entered(body:Node2D) -> void:
	if body is not Entity: return
	var entity:Entity = body
	entity.life.hurt(damage)


func _on_animated_sprite_animation_finished() -> void:
	queue_free()
