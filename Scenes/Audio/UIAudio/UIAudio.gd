class_name UIAudio extends AudioStreamPlayer

var audio_library:Dictionary[String, AudioStream] = {
	"level_up": preload("res://Assets/Sounds/LevelUp.wav"),
	"menu_tick": preload("res://Assets/Sounds/MenuTick.wav"),
	"menu_select": preload("res://Assets/Sounds/MenuSelect.wav"),
}


func play_audio(audio_name:String) -> void:
	if not audio_library.has(audio_name):
		push_error("UIAudio error: audio_name %s is invalid / not found" % [audio_name])
		return
	
	set_stream(audio_library[audio_name])
	play()
