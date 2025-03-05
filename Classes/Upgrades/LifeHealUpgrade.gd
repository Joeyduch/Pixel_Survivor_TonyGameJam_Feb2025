class_name LifeHealUpgrade extends BaseUpgrade

@export var health_bonus:int = 1


func apply(receiver:Entity) -> void:
	super(receiver)
	if receiver.life:
		receiver.life.heal(health_bonus)
	print("HEALING " + receiver.name + " FOR " + str(health_bonus) + " HEALTH")
