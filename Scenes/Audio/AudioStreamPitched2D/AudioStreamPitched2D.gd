class_name AudioStreamPitched2D extends AudioStreamPlayer2D


func play_random_pitched(pitched_scale_randomness:float=0.0) -> void:
	var random_offset:float = randf_range(-pitched_scale_randomness/2, pitched_scale_randomness/2)
	pitch_scale = 1 + random_offset
	play()
