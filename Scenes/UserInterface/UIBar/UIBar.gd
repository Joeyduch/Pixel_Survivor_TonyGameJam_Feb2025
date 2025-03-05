class_name UIBar extends NinePatchRect

@export var value:int = 0
@export var minimum:int = 0
@export var maximum:int = 10
@export var has_label:bool = true
@export var label_prefix:String = "LABEL"

@onready var foreground:ColorRect = $ForegroundRect
@onready var label:Label = $Label



func _ready() -> void:
	if not has_label:
		label.visible = false
	update_all()



func update_label() -> void:
	if has_label:
		label.text = label_prefix + ": " + str(value) + "/" + str(maximum)

func update_foreground() -> void:
	foreground.scale.x = clamp(remap(value, minimum, maximum, 0, 1), 0, 1)

func update_all() -> void:
	update_label()
	update_foreground()


func set_value(amount:int) -> void:
	value = amount
	update_all()
