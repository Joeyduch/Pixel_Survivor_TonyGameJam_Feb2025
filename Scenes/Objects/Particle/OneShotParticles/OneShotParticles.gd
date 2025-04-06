class_name OneShotParticles extends GPUParticles2D


func _ready() -> void:
	connect("finished", _on_finished)
	set_emitting(true)



func _on_finished() -> void:
	queue_free()
