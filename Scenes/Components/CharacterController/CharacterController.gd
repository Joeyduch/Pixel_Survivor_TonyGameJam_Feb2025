class_name CharacterController extends Node

@export var is_active:bool = true
@export var speed:int = 64
@export var is_input_controlled:bool = false

var parent:PhysicsBody2D = null
var direction:Vector2 = Vector2(0,0)



func _ready() -> void:
	set_parent(get_parent())


func _process(delta: float) -> void:
	if not parent or not is_active: return
	
	if is_input_controlled:
		var control_horizontal:int = int(Input.is_action_pressed("Control_Right")) - int(Input.is_action_pressed("Control_Left"));
		var control_vertical:int = int(Input.is_action_pressed("Control_Down")) - int(Input.is_action_pressed("Control_Up"));
		direction = Vector2(control_horizontal, control_vertical).normalized()
	
	move(delta)



func set_parent(new_parent:PhysicsBody2D) -> void:
	if new_parent is PhysicsBody2D:
		parent = new_parent


func set_direction(new_direction:Vector2) -> void:
	direction = new_direction.normalized()


func move(delta:float) -> void:
	parent.move_and_collide((direction*speed)*delta)
