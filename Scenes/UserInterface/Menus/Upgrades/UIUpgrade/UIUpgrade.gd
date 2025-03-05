class_name UIUpgrade extends Control

@export var holding_upgrade:BaseUpgrade = null: set = set_holding_upgrade

@onready var ui_border:NinePatchRect = $Border
@onready var ui_border_animation:AnimationPlayer = $Border/AnimationPlayer
@onready var ui_icon:TextureRect = $Icon



func _ready() -> void:
	set_holding_upgrade(holding_upgrade)



func set_holding_upgrade(upgrade:BaseUpgrade) -> void:
	holding_upgrade = upgrade
	if not upgrade: return
	
	if ui_icon:
		ui_icon.texture = upgrade.upgrade_icon


func blink() -> void:
	if not ui_border_animation: return
	
	var blinking_animation:Animation = ui_border_animation.get_animation("Blinking")
	blinking_animation.loop_mode = Animation.LOOP_LINEAR
	
	ui_border_animation.play("Blinking")


func unblink() -> void:
	if not ui_border_animation: return
	ui_border_animation.stop()
