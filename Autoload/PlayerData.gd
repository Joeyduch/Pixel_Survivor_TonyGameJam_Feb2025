extends Node

signal experience_gained(gain_amount:int, new_amount:int)
signal leveled_up(new_level:int, exp_to_level_up:int)

var experience:int = 0
var level:int = 0

var experience_for_level_up:int = calculate_experience_for_level_up()



func calculate_experience_for_level_up() -> int:
	return 3 + (5*level)


func gain_experience(exp_amount:int) -> void:
	experience += exp_amount
	var old_level:int = level
	while experience >= experience_for_level_up:
		level += 1
		experience = 0
		experience_for_level_up = calculate_experience_for_level_up()
	
	if level > old_level: leveled_up.emit(level, experience_for_level_up)
	experience_gained.emit(exp_amount, experience)
