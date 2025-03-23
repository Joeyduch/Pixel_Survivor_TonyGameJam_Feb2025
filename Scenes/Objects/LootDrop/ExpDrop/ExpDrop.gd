class_name ExpDrop extends LootDrop

@export var value:int = 1 # exp value



func collect(player_body:Entity) -> void:
	super(player_body)
	PlayerData.gain_experience(value)
	queue_free()
