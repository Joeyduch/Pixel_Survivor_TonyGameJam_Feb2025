class_name EntityThornUpgrade extends BaseUpgrade

@export var thorn_damage_bonus:int = 1

func apply(receiver:Entity) -> void:
	super(receiver)
	receiver.thorn_damage += thorn_damage_bonus
	print("ADDED %s THORN DAMAGE TO %s" % [thorn_damage_bonus, receiver.name])
