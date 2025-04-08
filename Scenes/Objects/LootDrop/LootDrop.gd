class_name LootDrop extends Area2D

@onready var animated_sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var lifetime_timer:Timer = $Lifetime
@onready var collect_audio:AudioStreamPitched2D = $CollectAudio
@onready var collision:CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	lifetime_timer.connect("timeout", _on_lifetime_timer_timeout)
	collect_audio.connect("finished", _on_collect_audio_finished)
	
	animated_sprite.play()



# METHODS

@warning_ignore("unused_parameter")
func collect(player_body:Entity) -> void:
	collision.set_deferred("disabled", true)
	animated_sprite.visible = false
	collect_audio.play()



# SIGNALS

func _body_entered(body:Node2D) -> void:
	if not body is Entity: return
	var entity:Entity = body
	
	if entity == entity.get_world().player:
		collect(entity)


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_collect_audio_finished() -> void:
	queue_free()
