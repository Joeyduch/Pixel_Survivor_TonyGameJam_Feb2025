class_name GameCamera extends Camera2D

@export var target_node:Node = null
@export var interpolation_scale:float = 0.05



func _process(_delta:float) -> void:
	if not target_node: return
	
	var viewport_size:Vector2i = get_viewport().get_visible_rect().size
	var position_offset:Vector2 = (viewport_size / 2) * -1
	position = lerp(position, target_node.position + position_offset, interpolation_scale)
