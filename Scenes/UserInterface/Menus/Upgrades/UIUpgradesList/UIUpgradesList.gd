class_name UIUpgradesList extends Control

@export var holding_upgrades_list:UpgradesList = null: set = set_holding_upgrades_list

@onready var ui_border:NinePatchRect = $Border
@onready var ui_border_animation:AnimationPlayer = $Border/AnimationPlayer
@onready var ui_icon:TextureRect = $Icon



func _ready() -> void:
	set_holding_upgrades_list(holding_upgrades_list)



func set_holding_upgrades_list(upgrades_list:UpgradesList) -> void:
	holding_upgrades_list = upgrades_list
	if not upgrades_list: return
	
	if ui_icon:
		ui_icon.texture = upgrades_list.list_thumbnail


func blink() -> void:
	if not ui_border_animation: return
	
	var blinking_animation:Animation = ui_border_animation.get_animation("Blinking")
	blinking_animation.loop_mode = Animation.LOOP_LINEAR
	
	ui_border_animation.play("Blinking")


func unblink() -> void:
	if not ui_border_animation: return
	ui_border_animation.stop()
