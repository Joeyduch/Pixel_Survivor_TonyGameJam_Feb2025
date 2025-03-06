class_name CharacterSpeedUpgrade extends BaseUpgrade

@export var speed_bonus:int = 5


func apply(receiver:Entity) -> void:
	super(receiver)
	if receiver.life:
		receiver.character_controller.speed += speed_bonus
	print("ADDING "+ str(speed_bonus) +" SPEED TO "+ receiver.name)
