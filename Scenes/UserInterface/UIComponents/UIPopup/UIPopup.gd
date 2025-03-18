class_name UIPopup extends PanelContainer

# export variables
@export var title:String = "Title"
@export var description:String = "Description"
@export var icon:Texture2D = null

@export var fadeout_animation_wait_time:float = 1

# onready variables
@onready var fadeout_wait_timer:Timer = $FadeoutWaitTimer
@onready var animation_player:AnimationPlayer = $AnimationPlayer

@onready var title_label:Label = $ListContainer/Title
@onready var description_label:Label = $ListContainer/Description
@onready var icon_texture_rect:TextureRect = $ListContainer/Icon



func _ready() -> void:
	# connect events
	fadeout_wait_timer.connect("timeout", _on_fadeout_wait_timer_timeout)
	animation_player.connect("animation_finished", _on_animation_player_finished)
	
	# setup popup
	title_label.text = title
	description_label.text = description
	if icon:
		icon_texture_rect.texture = icon
	
	# start fade in
	animation_player.play("FadeIn")



func _on_fadeout_wait_timer_timeout() -> void:
	animation_player.play("FadeOut")


func _on_animation_player_finished(anim_name:StringName) -> void:
	if anim_name == "FadeIn":
		animation_player.pause()
		fadeout_wait_timer.start(fadeout_animation_wait_time)
	elif anim_name == "FadeOut":
		queue_free()
