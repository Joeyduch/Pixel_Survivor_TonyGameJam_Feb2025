class_name UI extends CanvasLayer

@onready var hud:UIHUD = $HUD
@onready var menus:UIMenus = $Menus
@onready var audio:UIAudio = $UIAudio



func _ready() -> void:
	menus.connect("request_audio_play", _on_menus_request_audio_play)



func _main_game_paused(is_paused:bool) -> void:
	if is_paused:
		menus.set_menu(menus.MENUS.PAUSE)
	else:
		menus.set_menu(menus.MENUS.NONE)


func _on_menus_request_audio_play(audio_name:String) -> void:
	audio.play_audio(audio_name)
