class_name ExpDrop extends Area2D

@export var value:int = 1 # exp value

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	animated_sprite.play()



func _body_entered(body:Node2D) -> void:
	if not body is Entity: return
	var entity:Entity = body
	
	if entity == entity.get_world().player:
		PlayerData.gain_experience(value)
		queue_free()
