class_name UISmallBar extends Control

@export var value:int = 0: set = set_value
@export var minimum:int = 0: set = set_minimum
@export var maximum:int = 10: set = set_maximum

@onready var foreground:ColorRect = $Foreground



func _ready() -> void:
	update_bar()



func set_value(new_value:int) -> void:
	value = new_value
	update_bar()

func set_minimum(new_minimum:int) -> void:
	minimum = new_minimum
	update_bar()

func set_maximum(new_maximum:int) -> void:
	maximum = new_maximum
	update_bar()


func update_bar() -> void:
	foreground.scale.x = clamp(remap(value, minimum, maximum, 0, 1), 0, 1)
