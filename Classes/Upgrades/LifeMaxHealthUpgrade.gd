class_name LifeMaxHealthUpgrade extends BaseUpgrade

@export var max_health_bonus:int = 1


func apply(receiver:Entity) -> void:
	super(receiver)
	if receiver.life:
		receiver.life.max_health += max_health_bonus
	print("ADDING %s MAX-HEALTH TO %s" % [max_health_bonus, receiver.name])
