class_name BloodParticles extends OneShotParticles

@export var blood_color:Color = Color(172.0/255, 49.0/255, 49.0/255) # a red from the color palette



func _ready() -> void:
	super()
	set_blood_color(blood_color)



func set_blood_color(color:Color) -> void:
	if texture is not GradientTexture2D: return
	var gradient_texture:GradientTexture2D = texture
	var gradient:Gradient = gradient_texture.gradient
	for point:int in range(gradient.get_point_count()):
		gradient.set_color(point, color)
