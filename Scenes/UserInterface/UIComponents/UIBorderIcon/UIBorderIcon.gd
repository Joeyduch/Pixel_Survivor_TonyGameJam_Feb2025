@tool
class_name UIBorderIcon extends Control

@export var icon:Texture2D = null

@onready var ui_border:NinePatchRect = $Border
@onready var ui_border_animation:AnimationPlayer = $Border/AnimationPlayer
@onready var ui_icon:TextureRect = $Icon


func _ready() -> void:
	if icon:
		set_icon(icon)

func _process(_delta:float) -> void:
	if Engine.is_editor_hint() and icon:
		set_icon(icon)



func set_icon(texture:Texture2D) -> void:
	if texture and ui_icon:
		ui_icon.texture = texture


func blink() -> void:
	if not ui_border_animation: return
	
	var blinking_animation:Animation = ui_border_animation.get_animation("Blinking")
	blinking_animation.loop_mode = Animation.LOOP_LINEAR
	
	ui_border_animation.play("Blinking")


func unblink() -> void:
	if not ui_border_animation: return
	ui_border_animation.stop()
