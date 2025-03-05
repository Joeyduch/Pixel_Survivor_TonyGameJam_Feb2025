class_name Life extends Node

signal died
signal resurrected
signal health_changed(new_amount:int)
signal got_hurt(hurt_amount:int)
signal got_healed(heal_amount:int)

@export var max_health:int = 3

@onready var health:int = max_health: set = set_health, get = get_health

var is_dead:bool = false



func set_health(amount:int) -> void:
	health = clamp(amount, 0, max_health)
	# death
	var was_dead:bool = is_dead
	is_dead = health <= 0
	# signals emitting
	health_changed.emit(health)
	if not was_dead and is_dead:
		died.emit()
	if was_dead and not is_dead:
		resurrected.emit()

func get_health() -> int:
	return health


func hurt(damage:int) -> void:
	if is_dead: return
	
	damage = max(0, damage)
	set_health(health - damage)
	got_hurt.emit(damage)

func heal(amount:int, can_ressurect:bool=false) -> void:
	if is_dead and not can_ressurect:
		return
	
	amount = max(0, amount)
	set_health(health + amount)
	got_healed.emit(amount)
