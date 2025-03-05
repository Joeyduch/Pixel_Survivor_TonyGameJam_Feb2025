class_name EnemyDetector extends Area2D

@export var linked_life:Life = null
@export var team:int = -1


func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	



func _body_entered(body:Node2D) -> void:
	if not body is Entity: return
	if body.team != team and linked_life:
		linked_life.hurt(body.thorn_damage)
