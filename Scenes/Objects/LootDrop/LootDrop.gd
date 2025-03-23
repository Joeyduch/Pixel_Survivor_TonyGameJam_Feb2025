class_name LootDrop extends Area2D

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var lifetime_timer:Timer = $Lifetime



func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	lifetime_timer.connect("timeout", _on_lifetime_timer_timeout)
	animated_sprite.play()



# METHODS

@warning_ignore("unused_parameter")
func collect(player_body:Entity) -> void:
	pass



# SIGNALS

func _body_entered(body:Node2D) -> void:
	if not body is Entity: return
	var entity:Entity = body
	
	if entity == entity.get_world().player:
		collect(entity)


func _on_lifetime_timer_timeout() -> void:
	queue_free()
