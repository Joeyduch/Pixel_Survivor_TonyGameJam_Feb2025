class_name UISmallBar extends Control

@export var value:int = 0
@export var minimum:int = 0
@export var maximum:int = 10

@onready var foreground:ColorRect = $Foreground



func _ready() -> void:
	update_bar()



func set_value(new_value:int) -> void:
	value = new_value
	update_bar()


func update_bar() -> void:
	foreground.scale.x = clamp(remap(value, minimum, maximum, 0, 1), 0, 1)
