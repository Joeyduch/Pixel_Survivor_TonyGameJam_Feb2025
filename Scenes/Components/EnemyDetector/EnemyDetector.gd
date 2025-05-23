class_name EnemyDetector extends Area2D

@export var is_active:bool = true
@export var linked_entity:Entity = null
@export var team:int = -1


func _ready() -> void:
	connect("body_entered", Callable(_body_entered))
	


# hurt self if touches another Entity body
func _body_entered(body:Node2D) -> void:
	if not is_active or body is not Entity: return
	
	if body.team != team and linked_entity:
		linked_entity.hurt(body.thorn_damage)
