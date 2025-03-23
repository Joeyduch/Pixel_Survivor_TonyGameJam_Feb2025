class_name UIColorOverlay extends ColorRect

@onready var animation_player:AnimationPlayer = $AnimationPlayer



## plays the FadeIn animation
func fade_in(speed_scale:float=1) -> void:
	animation_player.speed_scale = speed_scale
	animation_player.play("FadeIn")

## plays the FadeOut animation
func fade_out(speed_scale:float=1) -> void:
	animation_player.speed_scale = speed_scale
	animation_player.play("FadeOut")


## Quickly flashes the overlay over a period of flash_time time
func flash(flash_time:float) -> void:
	animation_player.speed_scale = 2/flash_time
	
	print(animation_player.speed_scale)
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	animation_player.play("FadeOut")
	await animation_player.animation_finished
